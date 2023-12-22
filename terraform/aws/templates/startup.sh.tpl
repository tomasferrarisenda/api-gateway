# #!/bin/bash

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

mkdir /home/ubuntu/myapp
cd /home/ubuntu/myapp

git clone https://github.com/tomasferrarisenda/api.git .

npm install

npm install pm2 -g
pm2 start index.js
pm2 startup
pm2 save