#!/bin/bash

sudo apt update

sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

sudo DEBIAN_FRONTEND=noninteractive apt install nginx -y

sudo sed -i 's|try_files \$uri \$uri/ =404;|proxy_pass http://localhost:3000;|g' /etc/nginx/sites-available/default

sudo systemctl restart nginx

sudo systemctl enable nginx

curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh

sudo DEBIAN_FRONTEND=noninteractive bash nodesource_setup.sh

sudo DEBIAN_FRONTEND=noninteractive apt install nodejs -y

sudo npm install -g pm2




