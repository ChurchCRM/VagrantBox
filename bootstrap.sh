#!/usr/bin/env bash

echo $(whoami)

echo "=========================================================="
echo "================  Update Base System  ===================="
echo "=========================================================="
sudo apt-get -qq update
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
sudo apt-get -qq install -y software-properties-common apache2 

sudo apt-get -qq install -y php7.0 php7.0-mysql php7.0-xml php7.0-curl php7.0-gd libapache2-mod-php7.0 php7.0-mcrypt php7.0-mbstring

echo "=========================================================="
echo "==================   Apache Setup  ======================="
echo "=========================================================="
sudo mv /var/www/html /var/www/public
sudo cp /vagrant/apache/* /etc/apache2/sites-enabled/
sudo sed -i 's/^upload_max_filesize.*$/upload_max_filesize = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/^post_max_size.*$/post_max_size = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/^memory_limit.*$/memory_limit = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/^memory_limit.*$/memory_limit = 2G/g' /etc/php/7.0/cli/php.ini
sudo a2enmod php7.0 
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

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

echo "=========================================================="
echo "=================   Node Update    ==================="
echo "=========================================================="

sudo apt-get -qq install -y make
cd ~
git clone https://github.com/tj/n.git
cd n
make install
n 8.9.1
n rm 9.2.0
# Suggested for dev to not require sudo with npm -g
sudo chmod -R a+rwx /usr/local/
sudo chmod -R a+rwx /root
npm install -g npm@latest
npm install -g grunt-cli@latest
npm install -g i18next-extract-gettext
sudo npm install -g iltorb@latest --unsafe-perm=true

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
sudo locale-gen th_TH
sudo locale-gen ar_EG

echo "====================================="
echo "==========   Update Ruby ============"
echo "====================================="

sudo apt-get -qq install -y ruby gcc rubygems ruby-all-dev build-essential libsqlite3-dev

echo "================================================================================"
echo "==========   Install ChangeLog Generator SASS and Other Build Tools ============"
echo "================================================================================"

sudo gem install rake compass multi_json github_changelog_generator sass mailcatcher
sudo apt-get -qq install -y gettext

echo "======================================"
echo "==========   Add Swapfile ============"
echo "======================================"
sudo dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo chmod 0600 /var/swap.1 
sudo mkswap /var/swap.1
sudo swapon /var/swap.1

echo "/var/swap.1   swap    swap    sw  0   0" | sudo tee --append /etc/fstab