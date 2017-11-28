#!/usr/bin/env bash

echo "=========================================================="
echo "================  Update Base System  ===================="
echo "=========================================================="
#sudo apt-get -qq update
#sudo apt-get -qq dist-upgrade -y

echo "=========================================================="
echo "==================   disable unused stuff ================"
echo "=========================================================="
sudo chkconfig mongod off

echo "=========================================================="
echo "=======   Applying System Configuration    ==============="
echo "=========================================================="
#Display's ChurchCRM/box(version) at 'lsb_release -a'
echo "Updating lsb-release"
version=`cat /vagrant/version`
sudo sed -i 's/^DISTRIB_DESCRIPTION="/DISTRIB_DESCRIPTION="ChurchCRM\/box\('$version') - /g' /etc/lsb-release


echo "=========================================================="
echo "==========   Updating Vagrant Private Key     ============"
echo "=========================================================="
#
echo "Creating Vagrant user"
sudo useradd -m vagrant -s /bin/bash -d /home/vagrant
sudo usermod -aG sudo vagrant
echo -e "vagrant\nvagrant" | sudo passwd vagrant
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

echo "Updating SSH Key as per https://www.vagrantup.com/docs/boxes/base.html"
sudo mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
wget --no-check-certificate \
    https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
    -O /home/vagrant/.ssh/authorized_keys
    
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
sudo sed -i 's@^#AuthorizedKeysFile.*$@AuthorizedKeysFile %h/.ssh/authorized_keys@g' /etc/ssh/sshd_config
sudo service ssh restart

echo "=========================================================="
echo "==============   Configuring MySQL 5.7 ==================="
echo "=========================================================="
MYSQL_ROOT_PASSWORD='root'
echo debconf mysql-server/root_password password $MYSQL_ROOT_PASSWORD | sudo debconf-set-selections
echo debconf mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD | sudo debconf-set-selections

sudo apt-get -qq install -y mysql-server mysql-client


echo "=========================================================="
echo "================   Configuring PHP7.0 ===================="
echo "=========================================================="
sudo apt-get -qq install -y software-properties-common apache2 php7.0 php7.0-mysql php7.0-xml php7.0-curl php7.0-zip php7.0-mbstring php7.0-gd php7.0-mcrypt libapache2-mod-php7.0
sudo a2enmod php7.0
sudo service apache2 start

echo "=========================================================="
echo "==================   Apache Setup  ======================="
echo "=========================================================="
sudo mv /var/www/html /var/www/public
sudo cp /vagrant/apache/* /etc/apache2/sites-enabled/
sudo sed -i 's/^upload_max_filesize.*$/upload_max_filesize = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/^post_max_size.*$/post_max_size = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/^memory_limit.*$/memory_limit = 2G/g' /etc/php/7.0/apache2/php.ini
sudo a2enmod ssl rewrite
sudo a2ensite default-ssl
sudo service apache2 restart

echo "=========================================================="
echo "====================   DB Setup  ========================="
echo "=========================================================="
sudo sed -i 's/^bind-address.*$/bind-address=0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart

echo "=========================================================="
echo "=================   Composer Update    ==================="
echo "=========================================================="

sudo /usr/local/bin/composer self-update

echo "=========================================================="
echo "=================   Node Update    ==================="
echo "=========================================================="

sudo apt-get -qq install -y make
cd ~
git clone https://github.com/tj/n.git
cd n
sudo make install
sudo n 8.9.1
sudo n rm 9.2.0
sudo npm install -g npm@latest
sudo npm install -g grunt-cli@latest

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

sudo apt-get -qq install -y ruby gcc rubygems ruby-all-dev build-essential libsqlite3-dev

echo "=============================================================="
echo "==========   Install ChangeLog Generator and SASS ============"
echo "=============================================================="

sudo gem install rake compass multi_json github_changelog_generator sass mailcatcher
/usr/local/rvm/gems/ruby-2.3.3/bin/mailcatcher --ip 0.0.0.0
