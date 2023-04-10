#!/usr/bin/env dash

# VARIABLES #

hostname="fedora"


# FUNCTIONS

reboot_if_desired() {
  if [ "$1" = 'y' ]; then
    sudo reboot
  fi
}


# EXECUTION #

read -rp "welcome! starting now."

echo "changing hostname to $hostname..."
sudo hostnamectl set-hostname "$hostname"

echo "changing remote configurations to make downloads faster..."
sh ./components/fedora.sh

echo "updating everything and installing apps..."
sh ./components/install_apps.sh

echo "configuring gnome..."
sh ./components/gnome.sh

echo "configuring python..."
sh ./components/python.sh

echo "installing rust apps..."
sh ./components/rust.sh

echo "syncing dotfiles, configs and fonts..."
sh ./components/dotfiles.sh

echo "configuring git variables..."
sh ./components/config_git.sh

echo "setting zsh as default shell..."
sudo usermod --shell /bin/zsh "$USER"

echo ""
read -rp "do you want to reboot the system now? [y/N] " OPTION1

reboot_if_desired "$OPTION1"
