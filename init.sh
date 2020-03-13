#!/bin/sh

echo "Update and Upgrade Ubuntu 18.04"
apt update && apt upgrade -y  

echo "Create Swap"
swapon --show && free -h && df -h && fallocate -l 4G /swapfile && ls -lh /swapfile && chmod 600 /swapfile && ls -lh /swapfile && mkswap /swapfile && swapon /swapfile && swapon --show && free -h && cp /etc/fstab /etc/fstab.bak && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab 

echo "Install MongoDB"
apt autoremove -y && apt-get install gnupg && wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add - && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list && apt-get update && apt-get install -y mongodb-org  

echo "Disabled Upgrade MongoDB"
echo "mongodb-org hold" | sudo dpkg --set-selections && echo "mongodb-org-server hold" | sudo dpkg --set-selections && echo "mongodb-org-shell hold" | sudo dpkg --set-selections && echo "mongodb-org-mongos hold" | sudo dpkg --set-selections && echo "mongodb-org-tools hold" | sudo dpkg --set-selections 

echo "Enabled and Started MongoDB"
systemctl enable mongod.service && systemctl start mongod.service

echo "Move /etc/sysctl.conf"
mv ./lib/sysctl.conf /etc/sysctl.conf

echo "Move /lib/systemd/system/mongod.service"
mv ./lib/mongod.service /lib/systemd/system/mongod.service

echo "Move /etc/security/limits.conf"
mv ./lib/limits.conf /etc/security/limits.conf

echo "Reload Service"
systemctl daemon-reload

echo "Create Disable THP Service"
mv ./lib/disable-thp.service /etc/systemd/system/disable-thp.service

echo "Enabled and Started Disable THP Service"
systemctl enable disable-thp.service && systemctl start disable-thp.service

mongo <<EOF
use admin 
db.createUser({ user: "root", pwd: "123", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] })
exit
EOF

echo "Move Configuration MongoDB"
mv ./lib/mongod.conf /etc/mongod.conf

echo "Reload Service MongoDB"
systemctl restart mongod.service

echo "Access MongoDB"
mongo -u root -p 123 <<EOF
use tests
db.createUser({ user: "external_user", pwd: "123", roles: [ { role: "readWrite", db: "app" } ] })
EOF

apt-get purge do-agent
curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash
/opt/digitalocean/bin/do-agent --version