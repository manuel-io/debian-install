#!/bin/sh
# NETWORK

# NETWORK TOOLS
f "Install Network Tools?" && {
  apt-get install -y dnsutils \
                     net-tools \
                     ifupdown \
                     iproute2 \
                     iptables \
                     nftables \
                     wvdial \
                     wicd \
                     wicd-curses \
                     wpasupplicant \
                     wireless-tools \
                     tcpdump \
                     telnet
} && {
  # settings
  usermod -aG dialout,netdev $user
  systemctl enable wicd
}
