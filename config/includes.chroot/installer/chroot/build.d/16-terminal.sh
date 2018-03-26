#!/bin/sh
# TERMINAL TOOLS

# TERMINAL APPS
f "Install Terminal APPS?" &&
  apt-get install -y vim \
                     git \
                     zsh \
                     tmux \
                     traceroute \
                     whois \
                     nmap \
                     curl \
                     tree \
                     htop \
                     mutt \
                     links \
                     pv

# TERMINAL EXTRAS
f "Install Terminal Extras?" &&
  apt-get install -y rdiff-backup \
                     p7zip \
                     p7zip-full \
                     p7zip-rar \
                     unrar \
                     jmtpfs \
                     cpulimit \
                     gnome-keyring-query


