#!/bin/bash

. /installer/settings.sh

f() {
 echo $1
 read -p "Continue (y/N)?" choice
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
                   dnsutils \
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

cat > "/home/${user}/build.sh" <<EOF
#!/bin/bash

mkdir -p /home/${user}/repos
cd /home/${user}

git clone git@github.com:manuel-io/dotfiles.git repos/dotfiles
source /home/${user}/repos/dotfiles/bash/functions.sh
copy_dotfiles

git clone git@github.com:manuel-io/petridish.git repos/petridish
ln -s /home/${user}/repos/petridish/bin /home/${user}/bin

# Linuxbrew: The Homebrew package manager for Linux
curl -sSL https://raw.githubusercontent.com/Linuxbrew/install/master/install | ruby

# Ruby Version Manager
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
rvm install ruby --latest
rvm use ruby --default
gem install bundle

# Node Version Manager
curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
nvm install node
npm install -g coffeescript
EOF

chmod u+rwx "/home/${user}/build.sh"

/usr/sbin/locale-gen

update-initramfs -u -k all
update-grub
}

# USER SETTINGS
f "User Settings?" && {
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
apt-get install -y apt \
                   apt-file \
                   keyboard-configuration

# NETWORK TOOLS
f "Install Network Tools?" && {
  apt-get install -y dnsutils \
                     net-tools \
                     ifupdown \
                     iproute2 \
                     iptables \
                     nftables \
                     wvdial \
                     wicd \
                     wicd-curses \
                     wpasupplicant \
                     wireless-tools \
                     tcpdump \
                     telnet
} && {
  # settings
  usermod -aG dialout,netdev $user
  systemctl enable wicd
}

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
                   cpulimit \
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
                   keepassxc \
                   easytag

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
apt-get install -y mpv \
                   vlc \
                   mplayer \
                   mencoder \
                   vorbis-tools \
                   gpac \
                   libav-tools

# DVD SUPPORT
f "Install DVD Support?" && {
  apt-get install -y libdvd-pkg \
                     libdvdread4 \
                     libdvdnav4 \
                     lsdvd
} && {
  # settings
  dpkg-reconfigure libdvd-pkg
}

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

# ELIXIR
f "Install Elixir?" &&
apt-get install -y elixir

# AVR
f "Install AVR Tools?" && {
  apt-get install -y binutils-avr \
                     gcc-avr \
                     avr-libc \
                     avrdude
} && {
  # settings
  groupadd -g 501 usbasp
  groupadd -g 502 arduino
  usermod -aG usbasp,arduino $user
}

# ARM
f "Install ARM Tools?" &&
apt-get install -y gcc-arm-none-eabi

# SERVER TOOLS
f "Install Server Tools?" && {
  apt-get install -y fail2ban \
                     logwatch
} && {
  # settings
  systemctl stop fail2ban
  systemctl disable fail2ban
}

# VIRTUALIZATION TECHNOLOGIES
f "Install ARM Tools?" &&
apt-get install -y qemu-system-x86 \
                   qemu-user-static

#  POSTGRESQL SERVER
f "Install PostgreSQL Server?" && {
  apt-get install -y postgresql
} && {
  # settings
  systemctl stop postgresql
  systemctl disable postgresql
}

# WEB SERVER
f "Install Web Server Tools?" && {
  apt-get install -y nginx
} && {
  # settings
  systemctl stop nginx
  systemctl disable nginx
}

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
apt-get install -y libsdl2-dev \
                   libsdl2-image-dev \
                   libsdl2-ttf-dev \
                   zlib1g-dev \
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
                   devscripts \
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
                     firefox-quantum \
                     google-chrome-stable
}

# GRAPHICAL ENVIORNMENT
f "Graphical environment?" && {
  ln -s /usr/bin/slimlock /usr/local/bin/xflock4
  systemctl set-default graphical.target
}
