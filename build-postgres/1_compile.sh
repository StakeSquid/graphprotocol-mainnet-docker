#!/bin/bash

apt install -y software-properties-common
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get install -y gcc-10 g++-10 build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc git
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 --slave /usr/bin/g++ g++ /usr/bin/g++-10
git clone https://github.com/postgres/postgres.git
cd postgres/
git checkout REL_13_1
./configure CXXFLAGS="-march=native -O3" CFLAGS="-march=native -O3"
make
make install
cd contrib
make
make install
