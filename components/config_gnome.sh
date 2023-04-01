#!/usr/bin/env bash

# Switch Gnome's stock Alt+tab function to Windows'
dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['']"
dconf write /org/gnome/desktop/wm/keybindings/switch-applications-backward "['']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Super>Tab', '<Alt>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows-backward "['<Shift><Super>Tab', '<Shift><Alt>Tab']"
dconf write /org/gnome/shell/window-switcher/current-workspace-only false

# Switch Activate window menu to Alt+Shift+Space
dconf write /org/gnome/desktop/wm/keybindings/activate-window-menu "['<Alt><Shift>space']"

# Setting custom shortcuts
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

# Create Super + T shortcut for terminal
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'kitty'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Open Kitty terminal emulator'"

# Create Ulauncher shortcut
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Alt>Space'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'ulauncher-toggle'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'Open Ulauncher'"

# Change fonts
dconf write /org/gnome/desktop/interface/font-name "'Inter Regular 11'"
dconf write /org/gnome/desktop/interface/document-font-name "'Sans Regular 11'"
dconf write /org/gnome/desktop/interface/monospace-font-name "'Iosevka Regular 11'"
dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'Inter Bold 11'"

# Change format to Botswana(the same as Brazil but in English)
dconf write /system/locale/region "'en_BW.UTF-8'"

# Turn on over-amplification
dconf write /org/gnome/desktop/sound/allow-volume-above-100-percent true

# Change touchpad configurations
dconf write /org/gnome/desktop/peripherals/touchpad/natural-scroll true
dconf write /org/gnome/desktop/peripherals/touchpad/two-finger-scrolling-enabled true
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click true

# Making the PC not lock when it auto-locks
# dconf write /org/gnome/desktop/screensaver/lock-enabled false

# Not show gnome tweaks welcome message
dconf write /org/gnome/tweaks/show-extensions-notice false

# Not show gnome software welcome message
dconf write /org/gnome/software/first-run false

# Show weekday on clock
dconf write /org/gnome/desktop/interface/clock-show-weekday true

# Change scaling
# dconf write /org/gnome/desktop/interface/text-scaling-factor "1.45"

# Show battery percentage
dconf write /org/gnome/desktop/interface/show-battery-percentage true

# Disable acceleration
dconf write /org/gnome/desktop/peripherals/mouse/accel-profile "'flat'"

# Disable telemetry
# dconf write /org/gnome/desktop/privacy/report-technical-problems false

# Turn on minimize button and shuffle them to the right
dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize:appmenu'"

# Change GTK3 theme to Adwaita-dark
dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
