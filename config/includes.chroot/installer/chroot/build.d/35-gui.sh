#!/bin/sh
# GUI TOOLS

# APPLICATIONS
f "Install Applications?" &&
  apt-get install -y thunar \
                     thunar-vcs-plugin \
                     liferea \
                     evince \
                     seahorse \
                     thunderbird \
                     sqlitebrowser \
                     xfce4-terminal \
                     file-roller \
                     wicd-gtk \
                     viewnior \
                     gedit \
                     keepassx \
                     keepassxc

# LIBREOFFICE
f "Install Libreoffice?" &&
  apt-get install -y libreoffice-common \
                     libreoffice-math \
                     libreoffice-draw \
                     libreoffice-impress \
                     libreoffice-calc \
                     libreoffice-writer \
                     aspell \
                     aspell-de \
                     hunspell \
                     hunspell-de-de

# GRAPHICAL
f "Install Graphical?" &&
  apt-get install -y gimp \
                     inkscape \
                     scribus \
                     imagemagick \
                     gnuplot \
                     geda \
                     pcb \
                     feh

# MEDICAL
f "Install Medical?" &&
  apt-get install -y aeskulap

# MEDIA
f "Install Media?" &&
  apt-get install -y mpv \
                     vlc \
                     easytag \
                     asunder \
                     pavucontrol
