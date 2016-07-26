#!/bin/bash

usage="$(basename "$0") [-h] [-u, --user user name] [-dc, --dc docker-compose version] -- 
script to setup docker. Run as root:\n
    -h  show this help text\n
    -u, --user User name on the docker VM
    -dc, --dc docker-compose version you wish to install\n"

while [[ $# > 0 ]]
do
    key="$1"
    case $key in
        -u|--user)
            USER="$2"
            shift # past argument
            ;;
        -dc|--dc)
            DOCKER_COMPOSE="$2"
            shift # past argument
            ;;
        -h|--help)
            echo $usage
            exit
            ;;
    esac
    shift # past argument or value
done

mkdir -p ~/git

yum update

cat ./docker-repo.centos >> /etc/yum.repos.d/docker.repo

yum install docker-engine

service docker start

groupadd docker

usermod -aG docker $USER

curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

echo Log out and log back in.
