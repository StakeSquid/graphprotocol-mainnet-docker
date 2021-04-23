## Compile and run postgres outside of docker

Execute the bash files in the build-postgres folder in the below order and read and follow the printed out instructions carefully. 
In case of errors you will have to understand roughly what happens in the scripts to resolve them. 

***There is no customer support available.***

*Note:* The scripts assume you are running ubuntu.

***IMPORTANT:*** If you have a custom ssh port, change it in `2_configure.sh`

```
./1_compile.sh
./2_configure.sh
./3_optimize.sh
./start.sh
# ./stop.sh
```

This will take some minutes and needs you to edit several text files and change the system configuration. 

Add the following in front of you usual docker-compose up -d startup command that contains all your other environment variables

DB_HOST=$(ifconfig docker0 | awk '$1 == "inet" {print $2}')

It will set the internal ip address that allows docker containers to reach the postgres database running on the host

Note that your postgres will automatically come back up on system startup. It will be started by systemd on every reboot.