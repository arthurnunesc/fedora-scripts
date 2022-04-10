#!/usr/bin/env bash

link_arduino=https://downloads.arduino.cc/arduino-1.8.19-linux64.tar.xz

if [ ! -d "$HOME/Arduino" ]; then
    mkdir "$HOME"/Arduino
fi

wget -qcP "$HOME"/Arduino "$link_arduino"
tar -xf "$HOME"/Arduino/arduino-1.8.19-linux64.tar.xz -C "$HOME"/Arduino
rm "$HOME"/Arduino/arduino-1.8.19-linux64.tar.xz
sudo sh "$HOME"/Arduino/arduino-1.8.19/install.sh

sudo chmod a+rw /dev/ttyUSB0

pip3 install pyserial