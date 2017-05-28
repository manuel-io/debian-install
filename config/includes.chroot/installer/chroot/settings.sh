#!/bin/bash
uid=1100
user=manuel
device=/dev/sda
hostname=debian
groups="users,netdev,arduino,sudo,usbasp"
format="-c aes-xts-plain64 -h sha512 -s 512"
derived="/lib/cryptsetup/scripts/decrypt_derived"
