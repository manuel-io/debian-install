#!/bin/bash

base="http://ftp.debian.org/debian"
cd $(cd "$(dirname "$0")"; pwd)

[ $1 -eq 1 ] &&
for deb in `dpkg -l | cut -d\  -sf3`
do
  for file in `apt-cache show $deb | grep Filename | cut -d\  -sf2`
  do
    dpkg-deb --info "${file}" &> /dev/null || {
      echo $file
      apt-get download $deb
    }
  done
done

[ $1 -eq 2 ] &&
for file in `find . -maxdepth 1 -name '*.deb' -type f`
do
  package=$(basename "${file/_*//}")
  for filepath in `apt-cache show $package | grep Filename | cut -d\  -sf2`
  do
    dirpath=$(dirname $filepath)
    mkdir -p $dirpath
    cp -v $file ${filepath}
  done
  rm $file
done

[ $1 -eq 3 ] && {
  apt-ftparchive --arch amd64 packages pool/main > dists/stable/main/binary-amd64/Packages
  gzip -k dists/stable/main/binary-amd64/Packages

  apt-ftparchive --arch amd64 packages pool/contrib > dists/stable/contrib/binary-amd64/Packages
  gzip -k dists/stable/contrib/binary-amd64/Packages
  
  apt-ftparchive --arch amd64 packages pool/non-free > dists/stable/non-free/binary-amd64/Packages
  gzip -k dists/stable/non-free/binary-amd64/Packages

  apt-ftparchive contents pool/main > dists/stable/main/Contents-amd64
  gzip -k dists/stable/main/Contents-amd64

  apt-ftparchive contents pool/contrib > dists/stable/contrib/Contents-amd64
  gzip -k dists/stable/contrib/Contents-amd64

  apt-ftparchive contents pool/non-free > dists/stable/non-free/Contents-amd64
  gzip -k dists/stable/non-free/Contents-amd64

  apt-ftparchive release dists/stable/main/binary-amd64 > dists/stable/main/binary-amd64/Release
  apt-ftparchive release dists/stable/contrib/binary-amd64 > dists/stable/contrib/binary-amd64/Release
  apt-ftparchive release dists/stable/non-free/binary-amd64 > dists/stable/non-free/binary-amd64/Release
  apt-ftparchive release -c meta/release.conf dists/stable > dists/stable/Release

  # Replace $(id -un) with your desired gpg signing key

  gpg -a --yes --output dists/stable/Release.gpg --local-user $(id -un) --detach-sign dists/stable/Release
  gpg -a --yes --clearsign --output dists/stable/InRelease --local-user $(id -un) --detach-sign dists/stable/Release
}

[ $1 -eq 4 ] && {
  mkdir -p /packages/amd64
  rsync -rva * /packages/amd64
  find /packages -type d -exec chmod a+rx {} \;
  find /packages -type f -exec chmod a+r {} \;
}

[ $1 -eq 5 ] &&
debootstrap --keyring meta/manuel-io.gpg \
  --components main,contrib,non-free \
  --include linux-image-amd64,grub-pc,busybox,locales,cryptsetup,lvm2,zsh,vim \
  --arch amd64 stable /mnt file:/packages/amd64


