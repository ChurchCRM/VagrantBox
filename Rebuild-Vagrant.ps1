Write-Host "Destroying existing vagrant environment for fresh start"
vagrant destroy -f
vagrant box update
vagrant up
if (Test-Path churchcrm.box)
{
    Write-Host "Removing old box image"
    Remove-Item churchcrm.box
}
$captureBox = {
    Set-Location $args[0]
    vagrant package --output churchcrm.box
}
Start-Job $captureBox -Name "Package Vagrant Box" -ArgumentList $PSScriptRoot | Out-Null
Write-Host "Packaging Vagrant Box"
Wait-Job -Name "Package Vagrant Box"
$md5 = $(Get-FileHash -Algorithm md5 .\churchcrm.box).Hash
$sha1 = $(Get-FileHash -Algorithm SHA1 .\churchcrm.box).Hash
Write-Host "New Box Created $($PSScriptRoot)\churchcrm.box"
Write-Host "SHA1: $sha1"
Write-Host "MD5: $md5"
vagrant box remove ChurchCRM/box -f
vagrant box add .\churchcrm.box --name ChurchCRM/box
Write-Host "Destroying vagrant environment for clean up"
vagrant destroy -f