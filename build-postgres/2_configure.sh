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

echo "# add the following line above replication priviledges in the file"
echo "/usr/local/pgsql/data/pg_hba.conf"
echo "host    all             all             172.0.0.0/8             trust"
echo "host    all             all             192.168.0.0/16          trust"

echo "go to pgtune https://pgtune.leopard.in.ua/#/ and generate your database configuration"
echo "Webapplication is a good enough profile I guess."
echo "add the following line"
echo "listen_addresses = '*'"
echo "and store the file as "
echo "/usr/local/pgsql/data/postgresql.conf"

cp postgres.service /lib/systemd/system/postgres.service
systemctl enable postgres
