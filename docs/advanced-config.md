#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/docs/advanced-config.md) <- you are here
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/docs/logs.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/docs/troubleshooting.md)



## Building Postgres outside of Docker



In the [build-postgres](https://github.com/StakeSquid/graphprotocol-mainnet-docker/tree/master/build-postgres) folder you'll see a bunch of scripts. We highly recommend reading them to understand what they're all doing, first of all, then proceed with the installation.



### Compile and run postgres outside of docker

Execute the bash files in the build-postgres folder in the below order and read and follow the printed out instructions carefully. 
In case of errors you will have to understand roughly what happens in the scripts to resolve them. 

***Note:*** The scripts assume you are running ubuntu.

***IMPORTANT:*** If you have a custom ssh port, change it in `2_configure.sh`

```bash
cd build-postgres
./1_compile.sh
./2_configure.sh
./3_optimize.sh
./start.sh
# ./stop.sh
```

This will take some minutes and needs you to edit several text files and change the system configuration. 

Add the following in front of you usual docker-compose up -d startup command that contains all your other environment variables

```bash
DB_HOST=$(ifconfig docker0 | awk '$1 == "inet" {print $2}')
```

It will set the internal ip address that allows docker containers to reach the postgres database running on the host

Note that your postgres will automatically come back up on system startup. It will be started by systemd on every reboot.


