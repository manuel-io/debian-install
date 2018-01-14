#!/bin/sh
# DEBIAN BUILD

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

# DEBIAN EXTRA
f "Install Debian Extra?" &&
  apt-get install -y wimtools \
                     syslinux \
                     extlinux \
                     testdisk \
                     innoextract
