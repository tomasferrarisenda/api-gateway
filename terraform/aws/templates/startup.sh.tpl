# #!/bin/bash
# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Create a directory for your application and move into it
mkdir /home/ubuntu/myapp
cd /home/ubuntu/myapp

# Add your Node.js application files
cat <<'END' > index.js
${file("${path.module}/../api/index.js")}
END

# Install dependencies (if you have a package.json file)
cat <<'END' > package.json
${file("${path.module}/../api/package.json")}
END
npm install

# Install and start your application using a process manager like pm2
npm install pm2 -g
pm2 start index.js
pm2 startup
pm2 save