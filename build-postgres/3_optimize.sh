#!/bin/bash

apt install tuned

SYSCTL=/sbin/sysctl

echo "# add the output of this script to /etc/sysctl.conf,"
echo "# and then, as root, run"
echo
echo "# sysctl -p /etc/sysctl.conf"
echo
echo "# to load change the kernel settings for these parameters."
echo

PAGE_SIZE=`getconf PAGE_SIZE`

echo "# page size is: $PAGE_SIZE"

NUM_PHYS_PAGES=`getconf _PHYS_PAGES`

echo "# number of physical pages on this box: $NUM_PHYS_PAGES"

CURR_SHMALL=`$SYSCTL -n kernel.shmall`
PREF_SHMALL=`expr $NUM_PHYS_PAGES / 2`

echo "# kernel.shmall should be half of the number of pages. Current kernel.shmall, in pages, is: $CURR_SHMALL"
echo "# kernel.shmall should be:"
echo
echo "kernel.shmall = $PREF_SHMALL"
echo

CURR_SHMMAX=`$SYSCTL -n kernel.shmmax`
PREF_SHMMAX=`expr $PREF_SHMALL \* $PAGE_SIZE`

echo "# kernel.shmmax should be half of available RAM, in kB. Current kernel.shmmax, in kB, is: $CURR_SHMMAX"
echo "# kernel.shmmax should be:"
echo
echo "kernel.shmmax = $PREF_SHMMAX"
echo

# CURR_SHMMIN=`$SYSCTL -n kernel.shmmin`  # XXX: does not exist on linux
# CURR_SHMSEG=`$SYSCTL -n kernel.shmseg`  # XXX: does not exist on linux

CURR_SHMMNI=`$SYSCTL -n kernel.shmmni`

echo "# kernel.shmmni is usually set to a sane amount on Linux. Currently, it is: $CURR_SHMMNI"

# CURR_SEMMNI=`$SYSCTL -n kernel.semmni`  # XXX: does not exist on linux
# CURR_SHMMNI=`$SYSCTL -n kernel.semmns`  # XXX: does not exist on linux
# CURR_SHMMSL=`$SYSCTL -n kernel.semmsl`  # XXX: does not exist on linux
# CURR_SHMMSL=`$SYSCTL -n kernel.semmap`  # XXX: does not exist on linux
# CURR_SHMMSL=`$SYSCTL -n kernel.semmvx`  # XXX: does not exist on linux

CURR_SEM=`$SYSCTL -n kernel.sem`

echo "# kernel.sem usually has sane defauls. They are currently: $CURR_SEM"

echo "net.core.rmem_max = 4194304"
echo "net.core.wmem_max = 4194304"

echo "the following multiplied by the size of hugepages (on AMD EPYC = 2 MB) should be slightly bigger" 
echo "than your shared_buffers setting in postgresql.conf (8 GB on systems with 32 GB memory in total)."
echo "vm.nr_hugepages = 5000"


echo "add the following lines to /etc/security/limits.conf"

echo "postgres soft memlock 10000000"
echo "postgres hard memlock 10000000"

# tune cpu parameters
echo "on bare metal machines set the cpu performance profile as follows:"
echo "tuned-adm profile throughput-performance"

# reduce swappiness
echo 0 > /proc/sys/vm/swappiness