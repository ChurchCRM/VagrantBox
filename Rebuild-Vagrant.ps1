Write-Host "Destroying existing vagrant environment for fresh start"
vagrant destroy -f
$buildBox = {
    Set-Location $args[0]
    vagrant up
}
Start-Job $buildBox -Name "Build Vagrant Box" -ArgumentList $PSScriptRoot
Write-Host "Building Vagrant Box"
Wait-Job -Name "Build Vagrant Box"
if (Test-Path churchcrm.box)
{
    Write-Host "Removing old box image"
    Remove-Item churchcrm.box
}
$captureBox = {
    Set-Location $args[0]
    vagrant package --output churchcrm.box
}
Start-Job $captureBox -Name "Package Vagrant Box" -ArgumentList $PSScriptRoot
Write-Host "Packaging Vagrant Box"
Wait-Job -Name "Package Vagrant Box"
$md5 = Get-FileHash -Algorithm md5 .\churchcrm.box
$sha1 = Get-FileHash -Algorithm SHA1 .\churchcrm.box
Write-Host "New Box Created $($PSScriptRoot)\churchcrm.box"
Write-Host "SHA1: $sha1"
Write-Host "MD5: $md5"
vagrant box remove ChurchCRM/box1.2 -f
vagrant box add .\churchcrm.box --name ChurchCRM/box1.2
Write-Host "Destroying vagrant environment for clean up"
vagrant destroy -f