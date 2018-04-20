#!/usr/bin/env sh

sudo apt-get update
sudo apt-get upgrade
sudo apt-get autoremove

# setup RPI Monitor
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2C0D3C0F
sudo wget http://goo.gl/vewCLL -O /etc/apt/sources.list.d/rpimonitor.list

sudo apt-get install -y vim dirmngr git rpimonitor

# setup nodejs
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
source ~/.bashrc
nvm install 8
nvm use 8

vim --version
git --version
node --version

git clone https://github.com/mess110/laze-1.git
