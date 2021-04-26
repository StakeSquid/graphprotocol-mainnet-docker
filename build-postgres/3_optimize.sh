#!/bin/bash

apt install tuned

SYSCTL=/sbin/sysctl

echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"
echo
echo

echo -e "# add the output of this script to \e[1;31m /etc/sysctl.conf, \e[0m"
echo -e "# and then, as root, run the following command:"
echo     
echo -e "\e[1;33m  sysctl -p /etc/sysctl.conf \e[0m"
echo
echo -e "# to load change the kernel settings for these parameters."

echo
echo
echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"
echo
echo

PAGE_SIZE=`getconf PAGE_SIZE`

echo -e "# page size is: \e[1;31m $PAGE_SIZE \e[0m"

NUM_PHYS_PAGES=`getconf _PHYS_PAGES`

echo -e "# number of physical pages on this box: \e[1;31m $NUM_PHYS_PAGES \e[0m"


CURR_SHMALL=`$SYSCTL -n kernel.shmall`
PREF_SHMALL=`expr $NUM_PHYS_PAGES / 2`

echo 
echo -e "# kernel.shmall should be half of the number of pages. Current kernel.shmall, in pages, is: \e[1;31m $CURR_SHMALL \e[0m"
echo "# kernel.shmall should be:"
echo -e "\e[1;33m kernel.shmall = $PREF_SHMALL \e[0m"
echo
echo
echo

CURR_SHMMAX=`$SYSCTL -n kernel.shmmax`
PREF_SHMMAX=`expr $PREF_SHMALL \* $PAGE_SIZE`

echo -e "# kernel.shmmax should be half of available RAM, in kB. Current kernel.shmmax, in kB, is: \e[1;31m $CURR_SHMMAX \e[0m"
echo "# kernel.shmmax should be:"
echo -e "\e[1;33m kernel.shmmax = $PREF_SHMMAX \e[0m"
echo
echo
echo


echo "# add these too:"
echo -e "\e[1;33m net.core.rmem_max = 4194304 \e[0m"
echo -e "\e[1;33m net.core.wmem_max = 4194304 \e[0m"
echo
echo
echo

 
echo "# the following multiplied by the size of hugepages (on AMD EPYC = 2 MB) should be slightly bigger" 
echo "# than your shared_buffers setting in postgresql.conf (8 GB on systems with 32 GB memory in total)."
echo -e "\e[1;33m vm.nr_hugepages = 5000 \e[0m"

echo
echo
echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"
echo -e "\e[1;31m ################################################################################ \e[0m"
echo
echo

echo -e "# add the following lines to \e[1;31m /etc/security/limits.conf \e[0m"

echo -e "\e[1;33m  postgres soft memlock <number equal or more than shared mem in bytes> \e[0m"
echo -e "\e[1;33m  postgres hard memlock <number equal or more than shared mem in bytes> \e[0m"

echo
echo

# tune cpu parameters
echo -e "# on bare metal machines set the cpu performance profile as follows:"
echo -e "\e[1;33m  tuned-adm profile throughput-performance \e[0m"

# reduce swappiness
echo 0 > /proc/sys/vm/swappiness
