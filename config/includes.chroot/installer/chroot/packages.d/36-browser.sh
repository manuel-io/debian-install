#!/bin/sh
# INTERNET BROWSERS

# FIREFOX
f "Install Firefox?" &&
  apt-get install -y firefox-esr \
                     firefox-quantum
# GOOGLE CHROME
f "Install Chrome?" &&
  apt-get install -y google-chrome-stable
