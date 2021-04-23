#!/bin/bash

apt install -y ufw
ufw allow ssh
ufw allow from 172.0.0.0/8
ufw allow from 192.168.0.0/16
ufw allow from 127.0.0.0/8

echo "important: enabled a firewall"
ufw enable

adduser postgres --disabled-password

chown -R postgres:postgres /usr/local/pgsql

su -c "/usr/local/pgsql/bin/initdb --pgdata=/usr/local/pgsql/data --encoding=UTF8 --no-locale" postgres

echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"


echo -e "\e[1;33m add the following line above replication priviledges in the file \e[0m"
echo -e "\e[1;33m /usr/local/pgsql/data/pg_hba.conf \e[0m"
echo -e "\e[1;33m host    all             all             172.0.0.0/8             trust \e[0m"
echo -e "\e[1;33m host    all             all             192.168.0.0/16          trust \e[0m"


echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"



echo -e "\e[1;33m go to pgtune https://pgtune.leopard.in.ua/#/ and generate your database configuration \e[0m"
echo -e "\e[1;33m Webapplication is a good enough profile I guess. \e[0m"
echo -e "\e[1;33m add the following line \e[0m"
echo -e "\e[1;33m listen_addresses = '*' \e[0m"
echo -e "\e[1;33m and store the file as /usr/local/pgsql/data/postgresql.conf \e[0m"

cp postgres.service /lib/systemd/system/postgres.service
systemctl enable postgres
