#!/bin/bash

# Disable prompt when installing npm
sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf

sudo apt-get update
sudo apt-get install -y nodejs npm

mkdir /home/ubuntu/myapp
cd /home/ubuntu/myapp

git clone https://github.com/tomasferrarisenda/api.git .

sudo npm install
sudo npm install pm2 -g

pm2 start index.js