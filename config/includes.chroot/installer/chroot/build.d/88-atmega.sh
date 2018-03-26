#!/bin/sh
# ATMEGA

# AVR TOOLCHAIN
f "Install AVR Toolchain?" && {
  apt-get install -y binutils-avr \
                     gcc-avr \
                     avr-libc \
                     avrdude
} && {
  # settings
  groupadd -g 501 usbasp
  groupadd -g 502 arduino
  usermod -aG usbasp,arduino $user
}
