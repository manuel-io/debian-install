#!/bin/sh
# DEVEL ENVIRONMENT

# DEVEL TOOLS
f "Install Devel Tools?" &&
  apt-get install -y build-essential \
                     apt-utils \
                     apt-file \
                     make \
                     cmake \
                     gcc \
                     bison \
                     gawk \
                     alex \
                     debootstrap \
                     live-build \
                     xorriso

# DEVEL LIBRARIES
f "Install Devel Libraries?" &&
  apt-get install -y libsdl2-dev \
                     libsdl2-image-dev \
                     libsdl2-ttf-dev \
                     zlib1g-dev \
                     freeglut3-dev \
                     libwxbase3.0-dev \
                     libwxgtk-webview3.0-dev \
                     libwxgtk-media3.0-dev \
                     libgd-dev \
                     libpulse-dev \
                     libasound2-dev \
                     libmad0-dev \
                     libopusfile-dev \
                     libvorbis-dev \
                     libogg-dev \
                     libopenal-dev \
                     libxrandr-dev \
                     libfreetype6-dev \
                     libfribidi-dev \
                     libgl1-mesa-dev \
                     mesa-common-dev \
                     libjpeg-dev \
                     libpng-dev \
                     libbluetooth-dev \
                     libreadline-dev \
                     libssl-dev \
                     libyaml-dev \
                     libsqlite3-dev \
                     libgdbm-dev \
                     libbz2-dev \
                     libkrb5-dev \
                     libpq-dev

