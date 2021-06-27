#!/bin/bash
set -ex

## lhelper

#mkdir ~/bin
# Set PATH; workaround for AppVeyor plus lhelper prefix
#echo "export PATH=/usr/local/bin:~/bin:$PATH" >> ~/.bash_profile; source ~/.bash_profile
#git clone https://github.com/franko/lhelper.git; cd lhelper; bash install ~; cd ..

## Lite XL dependencies

# Install only if using external libraries
#brew install dylibbundler
#HOMEBREW_NO_AUTO_UPDATE=1
brew install freetype meson sdl2

## appdmg

cd ~; npm install appdmg; cd -
~/node_modules/appdmg/bin/appdmg.js --version
