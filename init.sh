#!/bin/sh
apt update && apt upgrade -y && swapon --show && free -h && df -h && fallocate -l 4G /swapfile && ls -lh /swapfile && chmod 600 /swapfile && ls -lh /swapfile && mkswap /swapfile && swapon /swapfile && swapon --show && free -h && cp /etc/fstab /etc/fstab.bak && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && apt autoremove -y && apt-get install gnupg && wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add - && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list && apt-get update && apt-get install -y mongodb-org && echo "mongodb-org hold" | sudo dpkg --set-selections && echo "mongodb-org-server hold" | sudo dpkg --set-selections && echo "mongodb-org-shell hold" | sudo dpkg --set-selections && echo "mongodb-org-mongos hold" | sudo dpkg --set-selections && echo "mongodb-org-tools hold" | sudo dpkg --set-selections && systemctl enable mongod.service && systemctl start mongod.service

mv ./lib/sysctl.conf /etc/sysctl.conf
mv ./lib/mongod.service /lib/systemd/system/mongod.service
mv ./lib/limits.conf /etc/security/limits.conf

systemctl daemon-reload

mv ./lib/disable-thp.service /etc/systemd/system/disable-thp.service

systemctl enable disable-thp.service && systemctl start disable-thp.service

# logica para acessar o banco de dados e fazer os procedimentos de criação de senha

# mongo 
# use admin
# db.createUser({ user: "root", pwd: "fba4a8683b7c7581da71f0412bdd6c4f8c3c7e83d6d55903e295bf3751e068ac", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] })

# mv ./lib/mongod.conf /etc/mongod.conf

# acessar mongodb e setar a senha
# mongo -u root -p

# rotina para criar banco e setar senha no banco

apt-get purge do-agent
curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash
/opt/digitalocean/bin/do-agent --version