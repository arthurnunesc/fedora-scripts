#!/usr/bin/env bash

# Install Arduino IDE
wget -P $HOME https://downloads.arduino.cc/arduino-1.8.13-linux64.tar.xz 
if [ ! -d "$HOME/Arduino" ]; then
    mkdir $HOME/Arduino
fi
tar -xf $HOME/arduino-1.8.13-linux64.tar.xz -C $HOME/Arduino
sudo sh $HOME/Arduino/arduino-1.8.13/install.sh
rm --force $HOME/arduino-1.8.13-linux64.tar.xz
