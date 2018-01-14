#!/bin/sh
# SYSTEM

# SYSTEM TOOLS
f "Install System Tools?" && {
  apt-get install -y apt \
                     apt-file \
                     keyboard-configuration \
                     lsof \
                     vim \
                     cpufrequtils \
                     heatmon
} && {
  update-alternatives --set editor /usr/bin/vim.basic
}

# PRINTING TOOLS
f "Install Printing Tools?" && {
  apt-get install -y cups \
                     system-config-printer \
                     ipsiosg
} && {
  # settings
  usermod -aG lpadmin $user
}

# SCANNING TOOLS
f "Install Scanning Tools?" &&
  apt-get install -y sane \
                     sane-utils \
                     libsane-extras \
                     simple-scan

# FONTS
f "Install Fonts?" &&
  apt-get install -y lmodern \
                     fonts-liberation \
                     ttf-dejavu \
                     fonts-thai-tlwg \
                     fonts-tomsontalks \
                     fonts-yanone-kaffeesatz \
                     fonts-jura \
                     ttf-mscorefonts-installer
