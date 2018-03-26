#!/bin/sh
# DEBIAN BUILD

# DEBIAN TOOLS
f "Install Data Recovery?" &&
  apt-get install -y foremost

# DEBIAN EXTRA
f "Install Forensic Tools?" &&
  apt-get install -y unhide \
                     rkhunter \
                     chkrootkit \
                     testdisk
