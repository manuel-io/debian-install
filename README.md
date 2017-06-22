## A personalized Linux operating system
![debian stretch](/share/stretch.png)

### Build the Live-System

    ./config/includes.binary/scripts/build.sh 123
    sudo lb build
    sudo dd if=live-image-amd64.hybrid.iso of=/etc/sdX

## Test your build with QEMU
    qemu-img create -f qcow2 debian.img 164G
    sudo qemu-system-x86_64 -enable-kvm -m 512 -hda debian.img -net none -boot d -cdrom live-image-amd64.hybrid.iso

### Build the System

Format the disk to match the following structure

    Device     Boot     Start       End   Sectors  Size Id Type
    /dev/sda1  *         2048  20973567  20971520   10G 83 Linux
    /dev/sda2        20973568 155191295 134217728   64G 8e Linux LVM
    /dev/sda3       155191296 364906495 209715200  100G 8e Linux LVM

## Format & Mount & Chroot

    /installer/build.sh 45678

## Finalize the build process

    /installer/build.sh 9
