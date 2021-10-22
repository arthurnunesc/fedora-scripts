#!/usr/bin/env bash

# Switch Gnome's stock Alt+tab function to Windows'
dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['']"
dconf write /org/gnome/desktop/wm/keybindings/switch-applications-backward "['']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Super>Tab', '<Alt>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows-backward "['<Shift><Super>Tab', '<Shift><Alt>Tab']"
dconf write /org/gnome/shell/window-switcher/current-workspace-only false

# Create Super + T shortcut for terminal
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'gnome-terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Open Terminal'"

# Change fonts to Fira Sans/Mono
dconf write /org/gnome/desktop/interface/document-font-name "'Fira Sans 11'"
dconf write /org/gnome/desktop/interface/font-name "'Fira Sans 11'"
dconf write /org/gnome/desktop/interface/monospace-font-name "'Fira Code 10'"
dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'Fira Sans Bold 11'"

# Show weekday on clock
dconf write /org/gnome/desktop/interface/clock-show-weekday true

# Change scaling
# dconf write /org/gnome/desktop/interface/text-scaling-factor "1.25"

# Show battery percentage
dconf write /org/gnome/desktop/interface/show-battery-percentage true

# Disable acceleration
dconf write /org/gnome/desktop/peripherals/mouse/accel-profile "'flat'"

# Disable telemetry
dconf write /org/gnome/desktop/privacy/report-technical-problems false

# Turn on minimize button
dconf write /org/gnome/desktop/wm/preferences/button-layout "'appmenu:minimize,close'"