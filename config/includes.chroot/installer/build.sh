#!/bin/bash

cmd=$@
rm -f /installer/chroot/free.img
. /installer/chroot/settings.sh

[[ $cmd =~ [45] ]] && {

  modify_settings

  sed -ir "s~^device=${old_device}~device=${device}~" /installer/chroot/settings.sh
  sed -ir "s/^uid=${old_uid}/uid=${uid}/" /installer/chroot/settings.sh
  sed -ir "s/^user=${old_user}/user=${user}/" /installer/chroot/settings.sh
  sed -ir "s/^groups=\"${old_groups}\"/groups=\"${groups}\"/" /installer/chroot/settings.sh
  sed -ir "s/^hostname=${old_hostname}/hostname=${hostname}/" /installer/chroot/settings.sh
}

[[ $cmd =~ [4] ]] && {
  echo "Stage 4 - LVM on LUKS"

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

  shred -u /fskey
  swapoff -a

  lvchange -an linux
  lvchange -an users

  cryptsetup luksClose linux
  cryptsetup luksClose users
}

[[ $cmd =~ [5] ]] && {
  echo "Stage 5 - root preparation"

  password=$(/lib/cryptsetup/askpass "Give the password")

  cryptsetup luksOpen "${device}2" linux <<< $password
  $derived linux | cryptsetup luksOpen "${device}3" users

  lvchange -ay linux
  lvchange -ay users

  $systempartition && {
    mkfs.ext2 -b 4096 -L boot "${device}1"
    mkswap -L swap /dev/mapper/linux-swap
    mkfs.ext4 -b 4096 -L root /dev/mapper/linux-root
    mkfs.ext4 -b 4096 -L home /dev/mapper/linux-home
  }

  $userpartition && {
    mkfs.ext4 -b 4096 -L "${user}" "/dev/mapper/users-${user}"
  }

  mount /dev/mapper/linux-root /mnt
  mkdir -p /mnt/boot /mnt/home

  mount "${device}1" /mnt/boot
  mount /dev/mapper/linux-home /mnt/home

  mkdir -p /mnt/home/workspace "/mnt/home/${user}"
  mount "/dev/mapper/users-${user}" "/mnt/home/${user}"
}

[[ $cmd =~ [6] ]] && {
  echo "Stage 6 - system preparation"

  debootstrap --keyring /packages/amd64/meta/local.gpg \
    --components main,contrib,non-free \
    --include linux-image-amd64,grub-pc,busybox,locales,cryptsetup,lvm2,zsh,vim \
    --arch amd64 stable /mnt file:/packages/amd64
}

[[ $cmd =~ [7] ]] && {
  echo "Stage 7 - chroot preparation"

  mount -o rbind /dev /mnt/dev
  mount -t proc  /proc /mnt/proc
  mount -t sysfs /sys /mnt/sys
  mount -o rbind /run/lvm /mnt/run/lvm
  mount -o rbind /run/lock/lvm /mnt/run/lock/lvm

  cp -fva /etc/resolv.conf /mnt/etc/resolv.conf
}

[[ $cmd =~ [8] ]] && {
  echo "Stage 8 - installing packages"

  mkdir -p /mnt/packages/amd64
  mkdir -p /mnt/installer

  rsync -rva --delete /packages/* /mnt/packages

  cp -fva /packages/amd64/meta/local.gpg /mnt/etc/apt/trusted.gpg.d/local.gpg
  cp -fva /packages/amd64/meta/local.list /mnt/etc/apt/sources.list.d/local.list

  rsync -rva --delete /installer/chroot/* /mnt/installer

  find /mnt/packages -type d -exec chmod a+rx {} \;
  find /mnt/packages -type f -exec chmod a+r {} \;
  find /mnt/installer -type d -exec chmod a+rx {} \;
  find /mnt/installer -type f -exec chmod a+r {} \;

  chroot /mnt /bin/bash
}
