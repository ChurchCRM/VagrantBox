# VagrantBox

Download from https://box.churchcrm.io/churchcrm.box

## Current Box:
  
  *  VirtualBox Integration Tools 5.1.10
  *  PHP 7.0 (from  ppa:ondrej/php)

  *  MD5:  593A78F9797DC235C20098A9EF868877
  *  SHA1: DD8166A17D211385D12FAE6B17BEDBA623CBBED7

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
