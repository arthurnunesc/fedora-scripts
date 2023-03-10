#!/usr/bin/env bash

# VARIABLES #

hostname="fedora"
hostname_desktop="fedora-desk"
hostname_laptop="fedora-lap"

dnf_apps=(
  ffmpeg
  gstreamer1-libav
  util-linux-user
  fuse-exfat
  gnome-tweaks
  dconf-editor
  neofetch
  rsms-inter-fonts
  mozilla-fira-sans-fonts
  jetbrains-mono-fonts
  meslo-lg-fonts
  piper
  libratbag-ratbagd
  zsh
  git
  stow
  code
  vim-enhanced
  neovim python3-neovim
  python3 python3-pip
  java-1.8.0-openjdk
  java-11-openjdk
  java-latest-openjdk
  nodejs
  rust cargo
)
dnf_apps_desktop_only=(
)

flatpak_apps=(
  # org.mozilla.firefox
  md.obsidian.Obsidian 
  com.transmissionbt.Transmission
  org.gnome.Extensions
  org.gnome.SoundRecorder
  org.gnome.Shotwell
  org.gimp.GIMP
  org.gabmus.hydrapaper
  nl.hjdskes.gcolor3
  com.belmoussaoui.Obfuscate
  com.obsproject.Studio
  com.github.tchx84.Flatseal
  com.spotify.Client
  com.discordapp.Discord
)
flatpak_apps_desktop_only=(
  org.gnome.Boxes
  org.desmume.DeSmuME
  net.lutris.Lutris
  com.valvesoftware.Steam
)

# TESTS #


# FUNCTIONS #

function change_hostname() {
  if [ "$1" -eq 1 ]; then
    hostname="$hostname_desktop"
  elif [ "$1" -eq 2 ]; then
    hostname="$hostname_laptop"
  fi
  sudo hostnamectl set-hostname "$hostname"
}

function merge_lists() {
  if [ "$1" -eq 1 ]; then
    for app in "${dnf_apps_desktop_only[@]}"; do
	  dnf_apps+=("$app")
	done
	for app in "${flatpak_apps_desktop_only[@]}"; do
		flatpak_apps+=("$app")
	done
  fi
}

function update_everything {
  sudo dnf update -y
  sudo dnf upgrade --refresh -y
  flatpak update -y
}

function update_repos_and_apps {
  sudo dnf update -y 
  flatpak update -y
}

function install_apps {
  for app in "${dnf_apps[@]}"; do
    if ! sudo dnf list --installed | grep -q "$app"; then
      sudo dnf install "$app" -y -q
      echo "Package $app was installed."
    else
      echo "Package $app was already installed."
    fi
  done

  for app in "${flatpak_apps[@]}"; do
    if ! flatpak list | grep -q "$app"; then
      flatpak install flathub "$app" -y --noninteractive
      echo "Package $app was installed."
    else
      echo "Package $app was already installed."
    fi
  done
}

function reboot_if_desired() {
  if [ "$1" -eq 1 ]; then
    sudo reboot
  fi
}

# EXECUTION #

read -rp "Welcome! In what device are you using this script in?
Type 1 for 'desktop' or 2 for 'laptop'
---------> " OPTION

change_hostname "$OPTION"

merge_lists "$OPTION"

# Changes Fedora remote configurations so downloads are faster
sh ./components/faster_downloads.sh

update_everything

# Add VSCode repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Add RPM Fusion free and nonfree repos
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y -q

# Add RPM Sphere repo
sudo dnf install https://raw.githubusercontent.com/rpmsphere/noarch/master/r/rpmsphere-release-36-1.noarch.rpm -y -q

# Add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

update_repos_and_apps

install_apps

# Create Projects folder and clone GitHub projects
if [ ! -d "$HOME/Projects" ]; then
  mkdir "$HOME"/Projects
fi

# Configures Gnome to my liking
sh ./components/config_gnome.sh

# Syncs dotfiles
sh ./components/sync_dotfiles.sh

# Configures git variables
sh ./components/config_git.sh

# Set zsh as default shell
sudo usermod --shell /bin/zsh "$USER"

update_everything

echo ""
read -rp "Do you want to reboot the system now?
Type 1 for 'yes' or 2 for 'no'
---------> "   OPTION1

reboot_if_desired "$OPTION1"
