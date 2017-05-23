#!/bin/bash
yum update -y
yum install docker -y
service docker start
docker network create --subnet 10.73.0.0/24 tinfishnw

docker run -d -h tinfish00_dps -p 30022:22 -p 8000:8000 --name tinfish00_dps --network tinfishnw --ip 10.73.0.69 tinfish/660prime

docker run -d -h tinfish09_clm -p 8001:8000 -e CLUSTERPASSWORD='$1' -e SIRE='10.73.0.69' --name tinfish09_clm --network tinfishnw --ip 10.73.0.60 tinfish/660drone
docker run -d -h tinfish08_idx -e CLUSTERPASSWORD='$1' -e SIRE='10.73.0.69' --name tinfish08_idx --network tinfishnw --ip 10.73.0.61 tinfish/660drone
docker run -d -h tinfish07_idx -e CLUSTERPASSWORD='$1' -e SIRE='10.73.0.69' --name tinfish07_idx --network tinfishnw --ip 10.73.0.62 tinfish/660drone
docker run -d -h tinfish06_idx -e CLUSTERPASSWORD='$1' -e SIRE='10.73.0.69' --name tinfish06_idx --network tinfishnw --ip 10.73.0.63 tinfish/660drone

docker run -d -h tinfish01_shd -p 8002:8000 -e CLUSTERPASSWORD='$1' -e SIRE='10.73.0.69' --name tinfish01_shd --network tinfishnw --ip 10.73.0.68 tinfish/660drone
