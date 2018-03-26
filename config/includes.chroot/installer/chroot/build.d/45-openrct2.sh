#/bin/sh
# OPENRCT2 GAME

# OPENRCT2
f "Install openRCT2?" &&
  apt-get install -y openrct2 \
                     rct2-original
# OPENRCT2 DEVEL
f "Install openRCT2 Devel?" &&
  apt-get install -y debhelper \
                     cmake \
                     libsdl2-dev \
                     libsdl2-ttf-dev \
                     gcc \
                     pkg-config \
                     libjansson4 \
                     libjansson-dev \
                     libspeex-dev \
                     libspeexdsp-dev \
                     libcurl4-openssl-dev \
                     libcrypto++-dev \
                     libfontconfig1-dev \
                     libfreetype6-dev \
                     libpng-dev \
                     libssl-dev \
                     libzip-dev
