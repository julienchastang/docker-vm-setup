#!/bin/bash

usage="$(basename "$0") [-h] [-u, --user user name] [-dc, --dc docker-compose version] -- 
script to setup docker. Run as root:\n
    -h  show this help text\n
    -u, --user User name on the docker VM\n
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
            DOCKER_COMPOSE_VERSION="$2"
            shift # past argument
            ;;
        -h|--help)
            echo -e $usage
            exit
            ;;
    esac
    shift # past argument or value
done


###
# https://docs.docker.com/engine/installation/linux/ubuntulinux/
###

apt-get -qq update

apt-get -qq install apt-transport-https ca-certificates

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee --append /etc/apt/sources.list.d/docker.list  > /dev/null

apt-get -qq update

apt-get -qq purge lxc-docker

apt-cache policy docker-engine

apt-get -qq update

apt-get install linux-image-extra-$(uname -r)

apt-get install apparmor

apt-get -qq update

apt-get -qq install docker-engine

groupadd docker

usermod -aG docker $USER

service docker start

###
# docker-compose
###

curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

###
# git
###

mkdir -p ~/git

apt-get install git

###
# Finalizing
###

echo 'sudo reboot' and log back in

echo Test with 'docker run hello-world'
