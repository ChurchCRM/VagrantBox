# VagrantBox

Download from https://box.churchcrm.io/churchcrm.box

## Current Box:
  
  *  VirtualBox Integration Tools 5.1.10
  *  PHP 7.0 (from  ppa:ondrej/php)

  *  MD5:  AD1BDAB2155C512DFC878E54219BEEEA
  *  SHA1: D1B9EFD1058B9DE5A4B59A76015916CEC40EA23A

## Updating the box:

  1.  Clone this repository
  2.  ```vagrant up```
  3.  Ensure that VirtualBox Guest addons are up to date
    * Installing https://github.com/dotless-de/vagrant-vbguest can ensure this.
  4.  Ensure all software in the box is up to date
    *  This should be handled by bootstrap.sh
  5. Ensure that the insecure private key is set
  6.  ```vagrant package --output churchcrm.box```
  
### References
  *  https://box.scotch.io/
  *  https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one
