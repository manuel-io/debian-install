#!/bin/sh
# LANGUAGES

# HASKELL 
f "Install Haskell?" &&
  apt-get install -y ghc \
                     haskell-platform \
                     cabal-install \
                     libghc-opengl-dev \
                     libghc-openglraw-dev \
                     libghc-hscolour-dev

# JAVASCRIPT / NODE
f "Install Javascript/Node?" &&
  apt-get install -y nodejs \
                     nodejs-legacy

# PYTHON
f "Install Python?" &&
  apt-get install -y python-pip \
                     python3-pip \
                     virtualenv

# RUBY
f "Install Ruby?" &&
  apt-get install -y ruby \
                     ruby-dev

# LUA
f "Install Lua?" &&
  apt-get install -y luarocks

# ERLANG
f "Install Lua?" &&
  apt-get install erlang-dev

# ELIXIR
f "Install Elixir?" &&
  apt-get install -y elixir
