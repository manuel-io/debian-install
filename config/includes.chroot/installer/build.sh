#!/bin/bash

. /installer/chroot/settings.sh

[ $1 -eq "2" ] && {
  echo "Stage 2 - system structure modeling"

  password=$(/lib/cryptsetup/askpass "Give a password")

  cryptsetup luksFormat $format "${device}2" <<< $password
  cryptsetup luksFormat $format "${device}3" <<< $password

  cryptsetup luksOpen "${device}2" linux <<< $password
  cryptsetup luksOpen "${device}3" users <<< $password

  /lib/cryptsetup/scripts/decrypt_derived linux > /fskey
  cryptsetup luksAddKey "${device}3" /fskey <<< $password

  pvcreate /dev/mapper/linux
  pvcreate /dev/mapper/users
  vgcreate linux /dev/mapper/linux
  vgcreate users /dev/mapper/users
  lvcreate -L 4G -n swap linux
  lvcreate -L 10G -n home linux
  lvcreate -l 100%FREE -n root linux
  lvcreate -l 100%FREE -n "${user}" users

  lvchange -ay linux
  lvchange -ay users

  mkswap -L swap /dev/mapper/linux-swap
  mkfs.ext2 -b 4096 -L boot "${device}1"
  mkfs.ext4 -b 4096 -L root /dev/mapper/linux-root
  mkfs.ext4 -b 4096 -L home /dev/mapper/linux-home
  mkfs.ext4 -b 4096 -L "${user}" "/dev/mapper/users-${user}"

  shred -u /fskey
  swapoff -a

  cryptsetup luksClose linux
  cryptsetup luksClose users
  shutdown -r now
}

[ $1 -eq "3" ] && {
  echo "Stage 3 - root preparation"

  password=$(/lib/cryptsetup/askpass "Give the password")

  cryptsetup luksOpen "${device}2" linux <<< $password
  $derived linux | cryptsetup luksOpen "${device}3" users

  lvchange -ay linux
  lvchange -ay users
    
  mount /dev/mapper/linux-root /mnt

  mkdir -p /mnt/boot /mnt/home /mnt/installer \
    /mnt/home/workspace "/mnt/home/${user}"

  mount /dev/mapper/linux-home /mnt/home
  mount "${device}1" /mnt/boot
}

[ $1 -eq "4" ] && {
  echo "Stage 4 - system preparation"

  debootstrap --keyring /installer/chroot/manuel-io.gpg \
    --components main,contrib,non-free \
    --include linux-image-amd64,grub-pc,locales,cryptsetup,lvm2,zsh,vim \
    --arch amd64 stable /mnt file:/packages/amd64
}

[ $1 -eq "5" ] && {
  echo "Stage 5 - chroot preparation"

  mount -o rbind /dev /mnt/dev
  mount -t proc  /proc /mnt/proc
  mount -t sysfs /sys /mnt/sys
  mount -o rbind /run/lvm /mnt/run/lvm
  mount -o rbind /run/lock/lvm /mnt/run/lock/lvm

  cp /etc/resolv.conf /mnt/etc/resolv.conf
}

[ $1 -eq "6" ] && {
  echo "Stage 6 - installing packages"

  cp -rv /installer/chroot/* /mnt/installer/
  cp -rv /packages/* /mnt/packages/
  chroot /mnt /bin/bash
}
