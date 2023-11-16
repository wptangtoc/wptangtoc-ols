#!/bin/bash
dnf remove python2-parsedatetime-2.4-6.el7 -y
dnf update -y
dnf upgrade -y
dnf upgrade --nobest -y
history
dnf clean all
clear

version_mariadb=$(cat /etc/yum.repos.d/MariaDB.repo | grep 'baseurl' | cut -f4 -d '/')
if [[ $version_mariadb = '' ]];then
	version_mariadb='10.5'
fi

echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/'$version_mariadb'/rhel8-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
module_hotfixes=1' >/etc/yum.repos.d/MariaDB.repo

rpm -Uvh http://rpms.litespeedtech.com/centos/litespeed-repo-1.3-1.el8.noarch.rpm
dnf clean all

dnf install openlitespeed -y

php_ver_chon='81'
dnf install lsphp${php_ver_chon} lsphp${php_ver_chon}-json lsphp${php_ver_chon}-common lsphp${php_ver_chon}-gd lsphp${php_ver_chon}-pecl-imagick lsphp${php_ver_chon}-process lsphp${php_ver_chon}-mbstring lsphp${php_ver_chon}-mysqlnd lsphp${php_ver_chon}-xml lsphp${php_ver_chon}-opcache lsphp${php_ver_chon}-pdo lsphp${php_ver_chon}-imap lsphp${php_ver_chon}-bcmath lsphp${php_ver_chon}-intl lsphp${php_ver_chon}-zip -y
php_ver_chon='74'
dnf install lsphp${php_ver_chon} lsphp${php_ver_chon}-json lsphp${php_ver_chon}-common lsphp${php_ver_chon}-gd lsphp${php_ver_chon}-pecl-imagick lsphp${php_ver_chon}-process lsphp${php_ver_chon}-mbstring lsphp${php_ver_chon}-mysqlnd lsphp${php_ver_chon}-xml lsphp${php_ver_chon}-opcache lsphp${php_ver_chon}-pdo lsphp${php_ver_chon}-imap lsphp${php_ver_chon}-bcmath lsphp${php_ver_chon}-intl lsphp${php_ver_chon}-zip -y

. /etc/wptt/wptt-reset

dnf remove MariaDB-server MariaDB-client -y
dnf install MariaDB-server MariaDB-client -y
systemctl start mariadb.service
systemctl enable mariadb.service

dnf update -y
dnf upgrade -y


