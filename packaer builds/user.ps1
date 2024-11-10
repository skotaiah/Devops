$username = "Hyper"
$password = "Radhi1234*"
New-LocalUser -Name $username -Description "test" -NoPassword
Set-LocalUser -Name $username -Password (ConvertTo-SecureString $password -AsPlainText -Force)
Add-LocalGroupMember -Group "administrators" -Member $username