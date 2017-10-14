try{
    Write-Host "Destroying existing vagrant environment for fresh start"
    vagrant destroy -f
    vagrant box update
    vagrant up
    Write-Host "Code: $LastExitCode"
    if ($LastExitCode -ne 0)
    {
        throw "Exception creating box.  stopping for debugging"
    }
    if (Test-Path churchcrm.box)
    {
        Write-Host "Removing old box image"
        Remove-Item churchcrm.box
    }
    Write-Host "Packaging Vagrant Box"
    vagrant package --output churchcrm.box
    $md5 = $(Get-FileHash -Algorithm md5 .\churchcrm.box).Hash
    $sha1 = $(Get-FileHash -Algorithm SHA1 .\churchcrm.box).Hash
    $Size = [Math]::Round($(Get-Item .\churchcrm.box).length / 1MB)
    Write-Host "New Box Created $($PSScriptRoot)\churchcrm.box ($Size MB)"
    Write-Host "SHA1: $sha1"
    Write-Host "MD5: $md5"
    vagrant box remove ChurchCRM/box -f
    vagrant box add .\churchcrm.box --name ChurchCRM/box
    Write-Host "Destroying vagrant environment for clean up"
    vagrant destroy -f
}
catch
{
    throw
}
