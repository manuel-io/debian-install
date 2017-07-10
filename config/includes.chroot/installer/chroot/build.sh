#!/bin/bash

. /installer/settings.sh

f() {
 echo $1
 read -p "Continue (y/n)?" choice
  case "$choice" in 
    y|Y) return 0;;
    n|N) return 1;;
      *) return 1;;
  esac
  return 1
}

# SYSTEM SETUP
f "System setup?" && {

grub-install $device

echo "${hostname}" > /etc/hostname
/bin/hostname "${hostname}"

passwd <<EOF
root
root
EOF

apt-get update
apt-get install -y coreutils \
                   util-linux \
                   pciutils \
                   usbutils \
                   dialog \
                   dbus \
                   debconf \
                   net-tools \
                   wpasupplicant \
                   wireless-tools \
                   dnsutils \
                   ifupdown \
                   iptables \
                   wicd \
                   wicd-curses \
                   kbd \
                   firmware*

update-initramfs -u -k all
update-grub
}

# SYSTEM CONFIG
f "System config?" && {

tar -pPxvf /installer/system.tar

cat >/etc/fstab <<EOF
UUID=$(blkid "${device}1" | cut -d\" -sf 4) /boot ext2  defaults             0 2
tmpfs                    /tmp                   tmpfs noatime,nodev,nosuid 0 0
tmpfs                    /home/workspace        tmpfs noatime,nodev,nosuid 0 0
/dev/mapper/linux-root   /                      ext4  errors=remount-ro    0 1
/dev/mapper/linux-home   /home                  ext4  defaults             0 2
/dev/mapper/linux-swap   none                   swap  sw                   0 0
/dev/mapper/users-$user /home/$user           ext4  defaults             0 2
EOF

cat > /etc/crypttab <<EOF
linux UUID=$(blkid "${device}2" | cut -d\" -sf 2) none luks
users UUID=$(blkid "${device}3" | cut -d\" -sf 2) none luks
EOF

/usr/sbin/locale-gen

systemctl enable lvm2
systemctl enable wicd

update-initramfs -u -k all
update-grub
}

# USER SETTINGS
f "User Settings?" && {
  groupadd usbasp
  groupadd arduino
  groupadd -g "${uid}" "${user}"
  useradd -u "${uid}" -g "${uid}" -G "${user},${groups}" -d "/home/${user}" -s /usr/bin/zsh "${user}"
  chown -R $user:$user "/home/${user}"
}

# UPDATE
apt-get update

f "Upgrade Sources?" && {
  apt-get upgrade
  apt-get dist-upgrade
}

# SYSTEM TOOLS
f "Install System Tools?" &&
apt-get install -y apt-file \
                   keyboard-configuration

# SOUND SYSTEM
f "Install Sound System?" &&
apt-get install -y libasound2 \
                   alsa-tools \
                   alsa-utils \
                   pulseaudio

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
                   feh

# TERMINAL EXTRAS
f "Install Terminal Extras?" &&
apt-get install -y rdiff-backup \
                   p7zip \
                   p7zip-full \
                   p7zip-rar \
                   unrar \
                   jmtpfs \
                   gnome-keyring-query

# XMONAD DESKTOP
f "Install Xmonad?" &&
apt-get install -y xmonad \
                   slim \
                   xsel \
                   scrot \
                   xserver-xorg-video-intel

# XFCE DESKTOP
f "Install XFCE?" &&
apt-get install -y xfce4 \
                   slim \
                   xserver-xorg-video-intel
# GUI APPS
f "Install GUI APPS?" &&
apt-get install -y liferea \
                   evince \
                   seahorse \
                   thunderbird \
                   sqlitebrowser \
                   xfce4-terminal \
                   file-roller \
                   wicd-gtk \
                   viewnior \
                   gedit \
                   pavucontrol \
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

# PRINTING TOOLS
f "Install Printing Tools?" &&
apt-get install -y cups \
                   system-config-printer \
                   ipsiosg

# SCANNING TOOLS
f "Install Scanning Tools?" &&
apt-get install -y sane \
                   sane-utils \
                   libsane-extras \
                   simple-scan

# GAMING TOOLS
f "Install Gaming Tools?" &&
apt-get install -y openrct2 \
                   rct2-original

# DATABASE TOOLS
f "Install Database Tools?" &&
apt-get install -y sqlite3 \
                   libsqlite3-dev \
                   postgresql-client

# LATEX ENVIRONMENT
f "LaTex Environment" &&
apt-get install -y texlive \
                   texlive-lang-german \
                   texlive-latex-extra \
                   texlive-metapost

# MEDICAL APPS
f "Install Medical Apps?" &&
apt-get install -y aeskulap

# MEDIA APPS
f "Install Media Apps?" &&
apt-get install -y vlc \
                   mplayer \
                   lsdvd \
                   normalize-audio \
                   vorbis-tools \
                   gpac \
                   mkvtoolnix \
                   mkvtoolnix-gui \
                   libav-tools \
                   libdvdread4 \
                   libdvdnav4

# MEDIA CODECS
f "Install Media Codecs?" &&
apt-get install -y libavcodec-extra \
                   libxvidcore4 \
                   gstreamer1.0-plugins-base \
                   gstreamer1.0-plugins-good \
                   gstreamer1.0-plugins-ugly \
                   gstreamer1.0-plugins-bad \
                   gstreamer1.0-alsa \
                   gstreamer1.0-fluendo-mp3 \
                   gstreamer1.0-libav

# GRAPHICAL APPS
f "Install Graphical Apps?" &&
apt-get install -y gimp \
                   inkscape \
                   imagemagick \
                   gnuplot \
                   geda \
                   pcb

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

# HASKELL 
f "Install Haskell?" &&
apt-get install -y ghc \
                   haskell-platform \
                   cabal-install \
                   libghc-opengl-dev \
                   libghc-openglraw-dev \
                   libghc-hscolour-dev

# JAVASCRIPT / NODE
f "Install Javascript/Node?" &&
apt-get install -y nodejs \
                   nodejs-legacy

# PYTHON
f "Install Python?" &&
apt-get install -y python-pip \
                   python3-pip \
                   virtualenv

# RUBY
f "Install Ruby?" &&
apt-get install -y ruby \
                   ruby-dev

# AVR
f "Install AVR Tools?" &&
apt-get install -y binutils-avr \
                   gcc-avr \
                   avr-libc \
                   avrdude
# ARM
f "Install ARM Tools?" &&
apt-get install -y gcc-arm-none-eabi

# WEB SERVER
f "Install Web Server Tools?" &&
apt-get install -y nginx

# MAIL SERVER
f "Install Mail Server Tools?" &&
apt-get install -y postfix \
                   procmail \
                   dovecot-imapd

# DEVEL TOOLS
f "Install Devel Tools?" &&
apt-get install -y build-essential \
                   apt-utils \
                   apt-file \
                   make \
                   cmake \
                   gcc \
                   bison \
                   gawk \
                   alex \
                   debootstrap \
                   live-build \
                   xorriso

# DEVEL LIBRARIES
f "Install Devel Libraries?" &&
apt-get install -y zlib1g-dev \
                   freeglut3-dev \
                   libwxbase3.0-dev \
                   libwxgtk-webview3.0-dev \
                   libwxgtk-media3.0-dev \
                   libgd-dev \
                   libpulse-dev \
                   libasound2-dev \
                   libmad0-dev \
                   libopusfile-dev \
                   libvorbis-dev \
                   libogg-dev \
                   libopenal-dev \
                   libxrandr-dev \
                   libcurl4-gnutls-dev \
                   libfreetype6-dev \
                   libfribidi-dev \
                   libgl1-mesa-dev \
                   mesa-common-dev \
                   libjpeg-dev \
                   libpng-dev \
                   libbluetooth-dev \
                   libreadline-dev \
                   libssl-dev \
                   libyaml-dev \
                   libsqlite3-dev \
                   libgdbm-dev \
                   libbz2-dev \
                   libkrb5-dev \
                   libpq-dev

# DEBIAN TOOLS
f "Install Debian Tools?" &&
apt-get install -y build-essential \
                   dpkg-dev \
                   debhelper \
                   dh-make \
                   quilt \
                   fakeroot \
                   lintian

# EXTRA PACKAGES
f "Install Extra Packages?" && {
  apt-get update
  apt-get install -y firefox-esr \
                     opera-stable \
                     google-chrome-stable
}

# GRAPHICAL ENVIORNMENT
f "Graphical environment?" &&
systemctl set-default graphical.target

systemctl disable dovecot
systemctl disable nginx
systemctl disable postfix

