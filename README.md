# VagrantBox

Download from https://box.churchcrm.io/churchcrm.box

## Current Box:
  
  *  VirtualBox Integration Tools 5.1.10
  *  PHP 7.0 (from  ppa:ondrej/php)

  *  MD5:  C0D3156B6584D559E7DBE1C45D08F273
  *  SHA1: 62B39AF45FD56BC96FF1094AD9D87E311A66C529

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
