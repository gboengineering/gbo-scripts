#!/bin/bash

DOCKER_VERSION="26.0"

OS_TYPE=$(grep -w "ID" /etc/os-release | cut -d "=" -f 2 | tr -d '"')
OS_VERSION=$(grep -w "VERSION_ID" /etc/os-release | cut -d "=" -f 2 | tr -d '"')

if [ $EUID != 0 ]; then
    echo "Please run as root"
    exit
fi

if [ "$OS_TYPE" != 'ubuntu' ]; then
    echo "Script can only be run at ubuntu machine"
    exit
fi

echo -e "-------------"
echo -e "Running installation scripts..."
echo -e "(Source code: https://github.com/gboengineering/gbo-scripts)\n"
echo -e "-------------"

echo "OS: $OS_TYPE $OS_VERSION"

if ! [ -x "$(command -v docker)" ]; then
    echo -e "Installing docker"
    curl https://releases.rancher.com/install-docker/${DOCKER_VERSION}.sh | sh
fi

if ! [ -x "$(command -v psql)" ]; then
    echo -e "Installing postgresql"
    sudo apt install curl ca-certificates
    sudo install -d /usr/share/postgresql-common/pgdg
    sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
    sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    sudo apt update
    sudo apt -y install postgresql
fi
