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

if [ -d "${PWD}/packages.d" ]
then
  for i in "${PWD}/packages.d"/*.sh
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
