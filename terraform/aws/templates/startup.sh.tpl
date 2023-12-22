# #!/bin/bash
sudo NEEDRESTART_MODE=a apt-get dist-upgrade --yes

sudo apt-get update
sudo apt-get install -y nodejs npm

mkdir /home/ubuntu/myapp
cd /home/ubuntu/myapp

git clone https://github.com/tomasferrarisenda/api.git .

npm install

node index.js