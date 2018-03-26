#!/bin/sh
# XTENSA

# XTENSA LX106
f "Install XTensa Lx106?" &&
  apt-get install -y xtensa-lx106

# XTENSA DEVEL
f "Install XTensa Devel?" && {
  apt-get install -y git \
                     autoconf \
                     build-essential \
                     gperf \
                     bison \
                     flex \
                     texinfo \
                     libtool \
                     libtool-bin \
                     libncurses5-dev \
                     wget \
                     mawk \
                     gawk \
                     libc6-dev \
                     python-serial \
                     libexpat1-dev \
                     help2man \
                     subversion
}
