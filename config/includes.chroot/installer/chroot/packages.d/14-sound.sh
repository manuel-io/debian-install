#!/bin/sh
# SOUND

# SOUND SYSTEM
f "Install Sound System?" &&
  apt-get install -y libasound2 \
                     alsa-tools \
                     alsa-utils \
                     pulseaudio

# SOUND ENGINEERING
f "Install Media Apps?" &&
  apt-get install -y mencoder \
                     vorbis-tools \
                     gpac \
                     libav-tools \
                     sox
