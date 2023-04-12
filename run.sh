#!/usr/bin/env dash

# VARIABLES #

hostname="fedora"

# Checks which OS we are in and sets the machine variable accordingly
uname_out="$(uname -s)"
case "${uname_out}" in
Linux*) machine=linux ;;
Darwin*) machine=mac ;;
*) machine="OTHER:${uname_out}" ;;
esac

# EXECUTION #
if [ "$machine" = "linux" ]; then
  echo "welcome! you are in a linux system, starting now."
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
  sh ./components/dotfiles.sh "linux"
  echo "configuring git variables..."
  sh ./components/git.sh
  echo "setting zsh as default shell..."
  sudo usermod --shell /bin/zsh "$USER"
  echo ""
  read -rp "do you want to reboot the system now? [y/N] " OPTION1
  if [ "$1" = 'y' ]; then
    sudo reboot
  fi
else
  echo "you are not in a linux system, running only non os specific components..."
  echo "configuring git variables..."
  sh ./components/git.sh
  echo "syncing dotfiles, configs and fonts..."
  sh ./components/dotfiles.sh "mac"
  echo "configuring python..."
  sh ./components/python.sh
fi
