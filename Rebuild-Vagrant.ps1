Write-Host "Destroying existing vagrant environment for fresh start"
$Version = Get-Content $PSScriptRoot\version
$TargetBoxFileName = "$PSScriptRoot\churchcrm$Version.box"
$TargetBoxName = "ChurchCRM/box$Version"
vagrant destroy -f
$buildBox = {
    Set-Location $args[0]
    vagrant up
}
Start-Job $buildBox -Name "Build Vagrant Box" -ArgumentList $PSScriptRoot
Write-Host "Building Vagrant Box"
Wait-Job -Name "Build Vagrant Box"
if (Test-Path $TargetBoxFileName)
{
    Write-Host "Removing old box image"
    Remove-Item $TargetBoxFileName
}
$captureBox = {
    Set-Location $args[0]
    vagrant package --output $args[1]
}
Start-Job $captureBox -Name "Package Vagrant Box" -ArgumentList $PSScriptRoot, $TargetBoxFileName
Write-Host "Packaging Vagrant Box"
Wait-Job -Name "Package Vagrant Box"
$md5 = Get-FileHash -Algorithm md5 $TargetBoxFileName
$sha1 = Get-FileHash -Algorithm SHA1 $TargetBoxFileName
Write-Host "New Box Created $TargetBoxFileName"
Write-Host "SHA1: $sha1"
Write-Host "MD5: $md5"
vagrant box remove $TargetBoxName -f
vagrant box add $TargetBoxFileName --name $TargetBoxName
#Write-Host "Destroying vagrant environment for clean up"
#vagrant destroy -f