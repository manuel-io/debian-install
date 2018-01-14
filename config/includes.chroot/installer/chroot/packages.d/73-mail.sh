#!/bin/sh
# MAIL

# POSTFIX SERVER
f "Install Postfix Server?" && {
  apt-get install -y postfix \
                     procmail
} && {
  # settings
  systemctl stop postfix
  systemctl disable postfix
}

# DOVECOT SERVER
f "Install Dovecot Server?" && {
  apt-get install -y dovecot-imapd
} && {
  # settings
  systemctl stop dovecot
  systemctl disable dovecot
}
