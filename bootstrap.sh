#!/usr/bin/env bash

echo "=========================================================="
echo "================  Update Base System  ===================="
echo "=========================================================="
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade -y

echo "=========================================================="
echo "=======   Applying System Configuration    ==============="
echo "=========================================================="
#Display's ChurchCRM/box(version) at 'lsb_release -a'
echo "Updating lsb-release"
version=`cat /vagrant/version`
sudo sed -i 's/^DISTRIB_DESCRIPTION="/DISTRIB_DESCRIPTION="ChurchCRM\/box\('$version') - /g' /etc/lsb-release
echo "Creating Vagrant user"
sudo useradd -m vagrant -s /bin/bash -d /home/vagrant
sudo usermod -aG sudo vagrant
echo -e "vagrant\nvagrant" | sudo passwd vagrant
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

echo "Updating SSH Key as per https://www.vagrantup.com/docs/boxes/base.html"
sudo curl -o /home/vagrant/.ssh/authorized_keys -s https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

exit

echo "=========================================================="
echo "==============   Configuring MySQL 5.7 ==================="
echo "=========================================================="
MYSQL_ROOT_PASSWORD='vagrant'
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
sudo sed -i 's/^upload_max_filesize.*$/upload_max_filesize = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/^post_max_size.*$/post_max_size = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/^memory_limit.*$/memory_limit = 2G/g' /etc/php/7.0/apache2/php.ini
sudo sed -i 's/\/var\/www.*$/\/var\/www\/public/g' /etc/apache2/sites-available/default-ssl.conf
sudo sed -i 's/\/var\/www.*$/\/var\/www\/public/g' /etc/apache2/sites-available/000-default.conf
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
echo "=====================   Node JS    ======================="
echo "=========================================================="

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get -qq install -y nodejs

echo "=========================================================="
echo "==========   Add Locales                       ============"
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

sudo apt-get -qq remove -y ruby
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

#gem install compass multi_json github_changelog_generator sass mailcatcher

#/usr/local/rvm/gems/ruby-2.4.0/bin/mailcatcher --ip 0.0.0.0

echo "=============================================================="
echo "================   Install Selenium WebDriver ================"
echo "=============================================================="
 
echo "Installing Firefox and Prerequisites"
sudo apt-get -qq install -y xvfb x11vnc firefox openjdk-8-jdk libxss1 libappindicator1 libindicator7 xdg-utils unzip

echo "Installing Google Chrome"
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome*.deb

echo "Downloading Selenium Server"
sudo wget -q https://goo.gl/s4o9Vx -O /opt/selenium/selenium-server.jar
echo "Downloading Gecko Driver"
sudo wget -q  https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-linux64.tar.gz -O /tmp/gecko.tar.gz
sudo tar -xzvf /tmp/gecko.tar.gz -C /opt/selenium/
echo "Downloading Chrome Driver"
sudo wget -q https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip -O /tmp/chrome.zip
sudo unzip /tmp/chrome.zip -d /opt/selenium/

echo "Configuring Xvfb, X11vnc, and Webdriver as Systemd services"
sudo mkdir /opt/selenium
sudo cp /vagrant/selenium/* /opt/selenium/
sudo ln -s /opt/selenium/xvfb.service /etc/systemd/system/xvfb.service
sudo ln -s /opt/selenium/x11vnc.service /etc/systemd/system/x11vnc.service
sudo ln -s /opt/selenium/webdriver.service /etc/systemd/system/webdriver.service
sudo systemctl daemon-reload

echo "Starting services"
sudo service xvfb start
sudo service x11vnc start
sudo service webdriver start