#!/bin/bash

free="config/includes.chroot/installer/chroot/free.img"
dd if=/dev/urandom of=$free count=1 bs=4096

[[ $@ =~ [1] ]] &&
lb config noauto \
  --apt apt \
  --apt-recommends true \
  --apt-secure true \
  --architecture amd64 \
  --binary-images iso-hybrid \
  --bootloader syslinux \
  --cache true \
  --cache-packages true \
  --cache-stages true \
  --chroot-filesystem squashfs \
  --debian-installer false \
  --debian-installer-gui false \
  --distribution stable \
  --initsystem systemd \
  --interactive false \
  --linux-flavours "amd64" \
  --linux-packages "linux-image linux-headers" \
  --parent-mirror-bootstrap http://ftp.de.debian.org/debian/ \
  --parent-mirror-chroot-security http://ftp.de.debian.org/debian-security/ \
  --parent-mirror-binary http://ftp.de.debian.org/debian/ \
  --parent-mirror-binary-security http://ftp.de.debian.org/debian-security/ \
  --mirror-bootstrap http://ftp.de.debian.org/debian/ \
  --mirror-chroot-security http://ftp.de.debian.org/debian-security/ \
  --mirror-binary http://ftp.de.debian.org/debian/ \
  --mirror-binary-security http://ftp.de.debian.org/debian-security/ \
  --mode debian \
  --archive-areas "main contrib non-free" \
  --system live \
  --security true \
  --firmware-binary true \
  --firmware-chroot true \
  --verbose

[[ $@ =~ [2] ]] &&
cat > config/package-lists/system.list.chroot <<EOF
coreutils
util-linux
pciutils
usbutils
cryptsetup
lvm2
dialog
dbus
debconf
syslinux
isolinux
xorriso
net-tools
wpasupplicant
wireless-tools
dnsutils
ifupdown
iptables
wicd
wicd-curses
debootstrap
grub-pc
kbd
EOF

[[ $@ =~ [3] ]] &&
cat > config/package-lists/terminal.list.chroot <<EOF
vim
zsh
htop
git
curl
less
links
EOF

find config -type d -exec chmod a+rx {} \;
find config -type f -exec chmod a+r {} \;
