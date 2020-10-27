#!/usr/bin/env bash

# Configure play/pause media keys

# Switch Gnome's stock Alt+tab function to Windows'
dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['']"
dconf write /org/gnome/desktop/wm/keybindings/switch-applications-backward "['']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Super>Tab', '<Alt>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows-backward "['<Shift><Super>Tab', '<Shift><Alt>Tab']"
dconf write /org/gnome/shell/window-switcher/current-workspace-only false

# Erase default printscreen shortcuts
dconf write /org/gnome/settings-daemon/plugins/media-keys/screenshot "['']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/area-screenshot "['']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/area-screenshot-clip "['']"

# Show weekday on clock
dconf write /org/gnome/desktop/interface/clock-show-weekday true

# Change fonts to Fira Sans/Mono
dconf write /org/gnome/desktop/interface/document-font-name "'Fira Sans 11'"
dconf write /org/gnome/desktop/interface/font-name "'Fira Sans 11'"
dconf write /org/gnome/desktop/interface/monospace-font-name "'Fira Mono 10'"

# Show battery percentage
dconf write /org/gnome/desktop/interface/show-battery-percentage true

# Disable acceleration
dconf write /org/gnome/desktop/peripherals/mouse/accel-profile "'flat'"

# Disable telemetry
dconf write /org/gnome/desktop/privacy/report-technical-problems false