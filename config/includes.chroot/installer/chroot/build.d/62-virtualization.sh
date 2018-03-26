#!/bin/sh
# VIRTUALIZATION TECHNOLOGIES

# QEMU X86
f "Install Qemu X86?" &&
  apt-get install -y qemu-system-x86 \
                     qemu-user-static

# QEMU ARM
f "Install Qemu ARM?" &&
  apt-get install -y qemu-system-arm
