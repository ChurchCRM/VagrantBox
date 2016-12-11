# VagrantBox

## Current Box:
  
  *  VirtualBox Integration Tools 5.1.10
  *  PHP 7.0 (from  ppa:ondrej/php)

  *  MD5:  2AE423D3EE961350526BC111C913B940
  *  SHA1: 1A9C1DBCF52573421BDC97B11863BC1C5A6B7B06

## Updating the box:

  1.  Clone this repository
  2.  ```vagrant up```
  3.  Ensure that VirtualBox Guest addons are up to date
  4.  Ensure all software in the box is up to date
    *  This should be handled by bootstrap.sh
  5. Ensure that the insecure private key is set
  6.  ```vagrant package --output churchcrm.box```
  
### References
  *  https://box.scotch.io/
  *  https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one
