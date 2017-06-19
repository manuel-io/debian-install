## A personalized Linux operating system
![debian stretch](/share/stretch.png)

### Build the Live-System

    ./config/includes.binary/scripts/build.sh 1234
    sudo lb build
    sudo dd if=live-image-amd64.hybrid.iso of=/etc/sdX

## Test your build with QEMU
    qemu-img create -f qcow2 debian.img 164G
    sudo tunctl -t tap0
    sudo ifconfig tap0 192.168.100.1 up
    sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
    sudo iptables -A FORWARD -i tap0 -j ACCEPT
    sudo iptables -A FORWARD -o tap0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo sysctl -w net.ipv4.ip_forward=1
    sudo qemu-system-x86_64 -enable-kvm -m 512 -hda debian.img -net nic -net tap,ifname=tap0,script=no -boot d -cdrom live-image-amd64.hybrid.iso

### Build the System

Format the disk to match the following structure

    Device     Boot     Start       End   Sectors  Size Id Type
    /dev/sda1  *         2048  20973567  20971520   10G 83 Linux
    /dev/sda2        20973568 155191295 134217728   64G 8e Linux LVM
    /dev/sda3       155191296 364906495 209715200  100G 8e Linux LVM

## Format

    /installer/build.sh 2

## After Reboot

Edit some setting using `vim /installer/chroot/settings.sh`
to set the installation device and give a valid username and hostname.

Connect the live system to a network (e.g. using `wicd-curses`)
which is required for the further install.

## Mount the system structure

    /installer/build.sh 3

## Build a minimal system

Make sure you have network connectivity
e.g. use wicd-curses

    /installer/build.sh 4

## Mount the chroot environment

    /installer/build.sh 5

## Chroot into the new system

    /installer/build.sh 6

## Finalize the build process

    /installer/build.sh
