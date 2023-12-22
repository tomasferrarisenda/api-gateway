# #!/bin/bash

sudo apt-get update
# sudo apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" nodejs npm
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
sudo apt-get install -y nodejs npm


# sudo apt-get install -y nodejs npm

mkdir /home/ubuntu/myapp
cd /home/ubuntu/myapp

git clone https://github.com/tomasferrarisenda/api.git .

npm install

node index.js