#!/bin/sh
# WEB

# NGINX SERVER
f "Install Web Server Tools?" && {
  apt-get install -y nginx
} && {
  # settings
  systemctl stop nginx
  systemctl disable nginx
}
