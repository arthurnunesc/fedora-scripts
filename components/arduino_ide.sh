#!/usr/bin/env bash

# Install Arduino IDE
cd
wget -c https://downloads.arduino.cc/arduino-1.8.13-linux64.tar.xz
if [ ! -d "$HOME/Arduino" ]; then
    mkdir $HOME/Arduino
fi
tar -xf arduino-1.8.13-linux64.tar.xz -C $HOME/Arduino
cd $HOME/Arduino/arduino-1.8.13/
sudo ./install.sh
cd
sudo rm --force arduino-1.8.13-linux64.tar.xz
