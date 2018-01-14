#!/bin/sh
# DESKTOP

# XMONAD DESKTOP
f "Install Xmonad?" &&
  apt-get install -y xmonad \
                     slim \
                     xsel \
                     scrot \
                     xserver-xorg-video-intel \
                     libnotify-bin

# XFCE DESKTOP
f "Install XFCE?" &&
  apt-get install -y xfce4 \
                     xfce4-cpufreq-plugin \
                     slim \
                     xserver-xorg-video-intel \
                     libnotify-bin
