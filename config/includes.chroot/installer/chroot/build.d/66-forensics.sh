#!/bin/sh
# DEBIAN BUILD

# DEBIAN TOOLS
f "Install Data Recovery?" &&
  apt-get install -y foremost

# DEBIAN EXTRA
f "Install Forensic Tools?" &&
  apt-get install -y cpuid \
                     unhide \
                     rkhunter \
                     chkrootkit \
                     testdisk
