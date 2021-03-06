#!/bin/bash

ifubuntu=$(cat /proc/version | grep ubuntu)
if14=$(cat /etc/issue | grep 14)

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
if [ $machine == "x86_64" ];then
  rm -rf mysql-5.1.73-linux-x86_64-glibc23
  if [ ! -f mysql-5.1.73-linux-x86_64-glibc23.tar.gz ];then
	 wget http://oss.aliyuncs.com/aliyunecs/onekey/mysql/mysql-5.1.73-linux-x86_64-glibc23.tar.gz
  fi
  tar -xzvf mysql-5.1.73-linux-x86_64-glibc23.tar.gz
  mv mysql-5.1.73-linux-x86_64-glibc23/* /alidata/server/mysql
else
  rm -rf mysql-5.1.73-linux-i686-glibc23
  if [ ! -f mysql-5.1.73-linux-i686-glibc23.tar.gz ];then
    wget http://oss.aliyuncs.com/aliyunecs/onekey/mysql/mysql-5.1.73-linux-i686-glibc23.tar.gz
  fi
  tar -xzvf mysql-5.1.73-linux-i686-glibc23.tar.gz
  mv mysql-5.1.73-linux-i686-glibc23/* /alidata/server/mysql
fi

if [ "$ifubuntu" != "" ] && [ "$if14" != "" ];then
	mv /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
fi

groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
/alidata/server/mysql/scripts/mysql_install_db --datadir=/alidata/server/mysql/data/ --basedir=/alidata/server/mysql --user=mysql
chown -R mysql:mysql /alidata/server/mysql/
chown -R mysql:mysql /alidata/server/mysql/data/
chown -R mysql:mysql /alidata/log/mysql
\cp -f /alidata/server/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir=/alidata/server/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir=/alidata/server/mysql/data#' /etc/init.d/mysqld
\cp -f /alidata/server/mysql/support-files/my-medium.cnf /etc/my.cnf
sed -i 's#skip-locking#skip-external-locking\nlog-error=/alidata/log/mysql/error.log#' /etc/my.cnf
chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start