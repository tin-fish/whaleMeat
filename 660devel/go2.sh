#!/bin/bash
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]
then
	echo "Usage go.sh <Cluster Pw> <Class C octets> <Hive> <Slack WebHook>"
	echo "go2.sh PASSWORD 192.168.0 master XXJSSHFF/SSHSHFFHD/SSSD"
	exit 2
else
	echo "Variables set!"
fi
echo "Doing the yum update..."
yum update -y
yum install docker -y
echo "Bringing in Docker..."
service docker start
docker network create --subnet $2.0/24 tinfishnw
echo $1
echo $2
echo $3
echo $4
docker run -d -h tinfish00_dps -p 30022:22 -p 8000:8000 -e CLUSTERPASSWORD=$1 -e HIVE=$3 -e SLACKHOOK=$4 -e NET=$2 -e IP=$2.69 --name tinfish00_dps --network tinfishnw --ip $2.69 tinfish/queen:latest
#sleep 60
docker run -d -h tinfish09_clm -p 8001:8000 -e CLUSTERPASSWORD=$1 -e SIRE=$2.69 -e HIVE=$3 -e SLACKHOOK=$4 -e NET=$2 --name tinfish09_clm --network tinfishnw --ip $2.60 tinfish/660drone:latest
sleep 60
docker run -d -h tinfish08_idx -e CLUSTERPASSWORD=$1 -e SIRE=$2.69 -e HIVE=$3 -e SLACKHOOK=$4 -e NET=$2 --name tinfish08_idx --network tinfishnw --ip $2.61 tinfish/660drone:latest
docker run -d -h tinfish07_idx -e CLUSTERPASSWORD=$1 -e SIRE=$2.69 -e HIVE=$3 -e SLACKHOOK=$4 -e NET=$2 --name tinfish07_idx --network tinfishnw --ip $2.62 tinfish/660drone:latest
docker run -d -h tinfish06_idx -e CLUSTERPASSWORD=$1 -e SIRE=$2.69 -e HIVE=$3 -e SLACKHOOK=$4 -e NET=$2 --name tinfish06_idx --network tinfishnw --ip $2.63 tinfish/660drone:latest
#sleep 30
#docker run -d -h tinfish01_shd -p 8002:8000 -e CLUSTERPASSWORD=$1 -e HIVE=$3 -e SLACKHOOK=$4 -e NET=$2 -e SIRE=$2.69 --name tinfish01_shd --network tinfishnw --ip $2.68 tinfish/drone:latest
#sleep 10
#docker run -d -h tinfish10_web_fwd -p 80:80 -e CLUSTERPASSWORD=$1 -e HIVE=$3 -e SLACKHOOK=$4 -e NET=$2 -e SIRE=$2.69 --name tinfish10_web_fwd --network tinfishnw --ip $2.224 tinfish/worker:latest
