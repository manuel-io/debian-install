#!/bin/bash

. /installer/settings.sh
PWD=$(cd $(dirname $0); pwd)

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
                   dpkg \
                   dnsutils \
                   kbd \
                   iucode-tool \
                   firmware*

update-initramfs -u -k all
update-grub
}

# SYSTEM CONFIG
f "System config?" && {

tar -pPxvf /installer/system.tar

cat >/etc/fstab <<EOF
UUID=$(blkid "${device}1" | cut -d\" -sf 4) /boot ext2 defaults    0 2
tmpfs                   /tmp            tmpfs noatime,nodev,nosuid 0 0
tmpfs                   /home/workspace tmpfs noatime,nodev,nosuid 0 0
/dev/mapper/linux-root  /               ext4  errors=remount-ro    0 1
/dev/mapper/linux-home  /home           ext4  defaults             0 2
/dev/mapper/linux-swap  none            swap  sw                   0 0
/dev/mapper/users-$user /home/$user     ext4  defaults             0 2
EOF

cat > /etc/crypttab <<EOF
linux UUID=$(blkid "${device}2" | cut -d\" -sf 2) none luks
users UUID=$(blkid "${device}3" | cut -d\" -sf 2) none luks
EOF

if [ -x "${PWD}/local.sh" ]
then
  ${PWD}/localbuild.sh $user
  chown -R "${user}:${user}" "/home/${user}/build.sh"
  chmod u=rwx,g=r,o=r "/home/${user}/build.sh"
fi
exit

/usr/sbin/locale-gen

update-initramfs -u -k all
update-grub
}

# USER SETTINGS
f "User Settings?" && {
  groupadd -g "${uid}" "${user}"
  useradd  -u "${uid}" \
           -g "${uid}" \
           -G "${user},${groups}" \
           -d "/home/${user}" \
           -s /usr/bin/zsh "${user}" && passwd $user

  chown -R $user:$user "/home/${user}"
}

# UPDATE
apt-get update

# UPGRADE SYSTEM
f "Upgrade Sources?" && {
  apt-get dist-upgrade
}

if [ -d "${PWD}/build.d" ]
then
  for i in "${PWD}/build.d"/*.sh
  do
    f "$(cat $i | head -2 | tail -1 | cut -d# -f 2)" &&
      . $i
  done
  unset i
fi

# GRAPHICAL ENVIORNMENT
f "Graphical environment?" && {
  ln -s /usr/bin/slimlock /usr/local/bin/xflock4
  systemctl set-default graphical.target
}
