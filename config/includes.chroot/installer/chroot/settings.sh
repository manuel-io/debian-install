#!/bin/bash

device=/dev/sda
uid=1100
user=admin
groups="users,sudo"
hostname=system
systempartition=false
userpartition=false
format="-c aes-xts-plain64 -h sha512 -s 512"
derived="/lib/cryptsetup/scripts/decrypt_derived"

old_device=$device
old_uid=$uid
old_user=$user
old_groups=$groups
old_hostname=$hostname

modify_settings() {
  while true
  do
    read -e -p "Device: " -i "${device}" -r device
    if [ -b $device ]
    then
      break
    fi
  done
  
  read -e -p "Uid: " -i "${uid}" -r uid
  read -e -p "User (${uid}): " -i "${user}" -r user
  read -e -p "Groups (${groups}): " -i "${groups}" -r groups
  read -e -p "Hostname (${hostname}): " -i "${hostname}" -r hostname
  
  read -p "Format system-partition? " -n 1 -r
  [[ $REPLY =~ ^[Yy]$ ]] && systempartition=true
  echo

  read -p "Format user-partition? " -n 1 -r
  [[ $REPLY =~ ^[Yy]$ ]] && userpartition=true
  echo
  
  echo "----------------------------------------------"
  echo "User (${uid}): ${user}"
  echo "Groups: ${groups}"
  echo "Hostname: ${hostname}"
  $systempartition && echo "Format system-partition"
  $systempartition || echo "Do not format system-partition"
  $userpartition && echo "Format user-partition"
  $userpartition || echo "Do not format user-partition"
  echo "----------------------------------------------"
  
  read -p "Do you want to continue? " -n 1 -r
  [[ $REPLY =~ ^[Yy]$ ]] || exit
  echo 
}
