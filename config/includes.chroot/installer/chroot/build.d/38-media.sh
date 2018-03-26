#!/bin/sh
# MEDIA

# MEDIA CODECS
f "Install Media Codecs?" &&
  apt-get install -y lame \
                     flac \
                     libopus0 \
                     wavpack \
                     libavcodec-extra \
                     libxvidcore4 \
                     gstreamer1.0-plugins-base \
                     gstreamer1.0-plugins-good \
                     gstreamer1.0-plugins-ugly \
                     gstreamer1.0-plugins-bad \
                     gstreamer1.0-alsa \
                     gstreamer1.0-fluendo-mp3 \
                     gstreamer1.0-libav

# DVD SUPPORT
f "Install DVD Support?" && {
  apt-get install -y libdvd-pkg \
                     libdvdread4 \
                     libdvdnav4 \
                     lsdvd
} && {
  # settings
  dpkg-reconfigure libdvd-pkg
}
