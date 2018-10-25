#!/bin/bash
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]
then
	echo "Usage splunk_env_start.sh <Cluster Pw> <Class C octets> <Hive> <Slack WebHook>"
	echo "nagios_env_start.sh PASSWORD 192.168.0 master XXJSSHFF/SSHSHFFHD/SSSD"
	exit 2
else
	echo "Variables set!"
fi
echo "Bringing in Docker..."
service docker start
docker network create --subnet $2.0/24 tinfishnw
echo $1
echo $2
echo $3
echo $4
docker run -d -it --name tinfish90_nag -h tinfish90_nag -p 80:80 -e APP_NAME=$3 -e APP_USER=admin -e APP_PASS='00pw00' --network tinfishnw --ip $2.169 appcontainers/nagios
