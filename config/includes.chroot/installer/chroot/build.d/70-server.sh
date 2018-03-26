#!/bin/sh
# SERVER ENVIRONMENT

# SERVER TOOLS
f "Install Server Tools?" && {
  apt-get install -y fail2ban \
                     logwatch
} && {
  # settings
  systemctl stop fail2ban
  systemctl disable fail2ban
}
