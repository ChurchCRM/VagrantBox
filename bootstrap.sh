#!/usr/bin/env bash

echo "=========================================================="
echo "==================   disable unused stuff ================"
echo "=========================================================="
sudo chkconfig mongod off

echo "=========================================================="
echo "================   Configuring PHP7.0 ===================="
echo "=========================================================="
sudo service apache2 stop
sudo apt-get install software-properties-common
sudo apt-get update
sudo apt-get install -y php7.0 php7.0-mysql php7.0-xml php7.0-curl php7.0-zip php7.0-mbstring php7.0-gd php7.0-mcrypt
sudo a2dismod php5
sudo a2enmod php7.0
sudo service apache2 start

echo "=========================================================="
echo "==================   Apache Setup  ======================="
echo "=========================================================="
sudo sed -i 's/^upload_max_filesize.*$/upload_max_filesize = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/^post_max_size.*$/post_max_size = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/^memory_limit.*$/memory_limit = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/\/var\/www.*$/\/var\/www\/public/g' /etc/apache2/sites-available/default-ssl.conf
sudo a2enmod ssl
sudo a2ensite default-ssl
sudo service apache2 restart

echo "=========================================================="
echo "====================   DB Setup  ========================="
echo "=========================================================="
sudo sed -i 's/^bind-address.*$/bind-address=0.0.0.0/g' /etc/mysql/my.cnf
sudo service mysql restart

echo "=========================================================="
echo "=================   Composer Update    ==================="
echo "=========================================================="

sudo /usr/local/bin/composer self-update

echo "=========================================================="
echo "=================   Node Update    ==================="
echo "=========================================================="

sudo n latest

echo "=========================================================="
echo "==========   Add Locals                       ============"
echo "=========================================================="

sudo locale-gen de_DE
sudo locale-gen en_AU
sudo locale-gen en_GB
sudo locale-gen es_ES
sudo locale-gen fr_FR
sudo locale-gen hu_HU
sudo locale-gen it_IT
sudo locale-gen nb_NO
sudo locale-gen nl_NL
sudo locale-gen pl_PL
sudo locale-gen pt_BR
sudo locale-gen ro_RO
sudo locale-gen ru_RU
sudo locale-gen se_SE
sudo locale-gen sq_AL
sudo locale-gen sv_SE
sudo locale-gen zh_CN
sudo locale-gen zh_TW

echo "====================================="
echo "==========   Update Ruby ============"
echo "====================================="


sudo pkill mailcatcher

sudo apt-get remove -y ruby
rbenv uninstall -f 2.2.2
rm -rf /home/vagrant/.rbenv

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source /usr/local/rvm/scripts/rvm

echo -e "\n\nsource /usr/local/rvm/scripts/rvm" >> /etc/bash.bashrc

sudo sed -i 's/^export PATH="\$HOME\/\.rbenv\/bin:\$PATH"$//g' /home/vagrant/.bashrc
sudo sed -i 's/^eval "\$(rbenv init -)"//g' /home/vagrant/.bashrc
sudo sed -i 's/^export PATH="\$HOME\/\.rbenv\/plugins\/ruby-build\/bin:\$PATH"$//g' /home/vagrant/.bashrc

echo "=============================================================="
echo "==========   Install ChangeLog Generator and SASS ============"
echo "=============================================================="

gem install compass multi_json github_changelog_generator sass mailcatcher

/usr/local/rvm/gems/ruby-2.3.3/bin/mailcatcher --ip 0.0.0.0

echo "=========================================================="
echo "==========   Updating Vagrant Private Key     ============"
echo "=========================================================="

wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub > ~/.ssh/authorized_keys
