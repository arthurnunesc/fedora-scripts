#!/usr/bin/env bash

# I couldn't make these commands to run on the script and work, so I run them manually #

# Install Arduino IDE
wget -c https://downloads.arduino.cc/arduino-1.8.13-linux64.tar.xz
mkdir Arduino
tar -xf arduino-1.8.13-linux64.tar.xz -C /home/arthur/Arduino
cd Arduino/arduino-1.8.13/
sudo ./install.sh
cd
sudo rm --force arduino-1.8.13-linux64.tar.xz

# Configure play/pause media keys

# Switch Gnome's stock Alt+tab function to Windows'
function alttab_from_apps_to_windows {
  dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-applications-backward "['']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Super>Tab', '<Alt>Tab']"
  dconf write /org/gnome/desktop/wm/keybindiSngs/switch-windows-backward "['<Shift><Super>Tab', '<Shift><Alt>Tab']"
  dconf write /org/gnome/shell/window-switcher/current-workspace-only false
}

# Erase default printscreen shortcuts
function erase_print_shortcuts {
  dconf write /org/gnome/settings-daemon/plugins/media-keys/screenshot "['']"
  dconf write /org/gnome/settings-daemon/plugins/media-keys/area-screenshot "['']"
  dconf write /org/gnome/settings-daemon/plugins/media-keys/area-screenshot-clip "['']"
}

# Set Flameshot shorcuts

# Flameshot setup
flameshot config --showhelp false --autostart true --trayicon true --maincolor '#505050' --contrastcolor '#000000'