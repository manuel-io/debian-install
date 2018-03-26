#!/bin/sh
# LATEX & CO

# LATEX
f "LaTex Environment" &&
  apt-get install -y texlive \
                     texlive-lang-german \
                     texlive-latex-extra

# METAPOST
f "Metapost" &&
  apt-get install -y texlive-metapost
