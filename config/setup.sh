#!/usr/bin/env bash
#Setup initial env
set -e
apt-get update

apt-get -y install \
  nginx \
  docker \
  docker.io \
  docker-compose

# required for non root users to stop/start containers - in this case vagrant
sudo usermod -a -G docker $USER

# Build applications
docker build -t cat /mnt/application/cat
docker build -t goat /mnt/application/goat
docker-compose -f /mnt/application/dog/docker-compose.yml pull

# Start applications
docker run -d -p 3000:3000 cat
docker run -d -p 9000:9000 goat
docker-compose -f /mnt/application/dog/docker-compose.yml up -d

# Setup main nginx config
cp /mnt/config/default.conf /etc/nginx/sites-enabled/default
rm /usr/share/nginx/html/index.html
systemctl restart nginx

