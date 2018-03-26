#!/bin/sh
# ACORN RISC MACHINES

# ARM TOOLCHAIN
f "Install ARM Toolchain?" &&
apt-get install -y gcc-arm-none-eabi

# QEMU ARM
f "Install Qemu ARM?" &&
  apt-get install -y qemu-system-arm
