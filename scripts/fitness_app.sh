#!/bin/bash

set -e

exec > >(tee /var/log/bootstrap.log) 2>&1

APP_USER="shubha2001"
APP_HOME="/home/$APP_USER"
APP_DIR="$APP_HOME/Fitness_Tracker"
APP_PORT="3000"
REPO_URL="https://github.com/Shubha-KA/Fitness_Tracker.git"
MONGO_DB_NAME="fitnesstracker"

rm -f /etc/apt/sources.list.d/mongodb-org-7.0.list
rm -f /usr/share/keyrings/mongodb-server-7.0.gpg

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

apt-get install -y \
    nginx \
    git \
    curl \
    wget \
    gnupg \
    ca-certificates \
    software-properties-common

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

apt-get install -y nodejs

npm install -g pm2

curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg

echo "deb [ arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
tee /etc/apt/sources.list.d/mongodb-org-7.0.list

apt-get update -y

apt-get install -y mongodb-org

systemctl enable mongod
systemctl start mongod

systemctl enable nginx
systemctl start nginx

cd $APP_HOME

rm -rf $APP_DIR || true

git clone $REPO_URL

cd $APP_DIR

if [ -f ".env.example" ]; then
    cp .env.example .env
fi

cat <<EOF > .env
PORT=$APP_PORT
NODE_ENV=production
MONGO_URI=mongodb://127.0.0.1:27017/$MONGO_DB_NAME
EOF

npm install

if [ -d "server" ]; then
    cd server
    npm install
    cd ..
fi

pm2 delete all || true

pm2 start server/app.js --name "fitness-tracker"

pm2 save

pm2 startup systemd -u $APP_USER --hp $APP_HOME

rm -f /etc/nginx/sites-enabled/default || true

cat <<EOF > /etc/nginx/sites-available/fitness-tracker
server {

    listen 80;

    server_name _;

    location / {

        proxy_pass http://127.0.0.1:$APP_PORT;

        proxy_http_version 1.1;

        proxy_set_header Upgrade \$http_upgrade;

        proxy_set_header Connection 'upgrade';

        proxy_set_header Host \$host;

        proxy_cache_bypass \$http_upgrade;
    }

    location /health {

        return 200 'healthy';

        add_header Content-Type text/plain;
    }
}
EOF

ln -sf /etc/nginx/sites-available/fitness-tracker /etc/nginx/sites-enabled/fitness-tracker

nginx -t

systemctl restart nginx
systemctl enable nginx

sleep 20

curl http://127.0.0.1/health || true