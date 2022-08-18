#!/bin/bash

# install nginx
apt-get update -y
apt-get install -y nginx

# start nginx
systemctl start nginx