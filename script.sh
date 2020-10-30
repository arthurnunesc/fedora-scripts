#!/usr/bin/env bash

# VARIABLES #

my_user="arthur"
hostname="localhost"
hostname_desktop="fedora-desktop"
hostname_laptop="fedora-laptop"

dnf_apps=(
  git
  vim
  ffmpeg
  gstreamer1-libav
  fuse-exfat
  gnome-tweaks
  htop
  neofetch
  mozilla-fira-sans-fonts
  mozilla-fira-mono-fonts
  fira-code-fonts
  nautilus-dropbox
  https://release.axocdn.com/linux/gitkraken-amd64.rpm # GitKraken
  winehq-staging
  gcc-c++ make # NodeJS build tools
  ansible
  python-psutil # Ansible dconf dependency
  cmake # Alacritty build dependency
)
dnf_apps_desktop_only=(
  piper
  lutris
  steam
)

flatpak_apps=(
  com.spotify.Client # non-official
  com.discordapp.Discord # non-official
)
flatpak_apps_desktop_only=(
)

# TESTS #


# FUNCTIONS #

function change_hostname() {
  if [ $1 -eq 1 ]; then
    hostname="$hostname_desktop"
  elif [ $1 -eq 2 ]; then
    hostname="$hostname_laptop"
  fi
  hostnamectl set-hostname "$hostname"
}

function merge_lists() {
  if [ $1 -eq 1 ]; then
  for app in "${dnf_apps_desktop_only[@]}"; do
    dnf_apps+=("$app")
  done
  for app in "${flatpak_apps_desktop_only[@]}"; do
    flatpak_apps+=("$app")
  done
  fi
}

function update_everything {
  dnf update -y -q
  dnf upgrade --refresh -y -q
  flatpak update -y --noninteractive
}

function update_repos_and_apps {
  dnf update -y -q
  flatpak update -y --noninteractive
}

function install_apps {
  for app in "${dnf_apps[@]}"; do
    if ! dnf list --installed | grep -q $app; then
      dnf install $app -y -q
      echo ""
      echo "$app was installed"
      echo ""
    else
      echo ""
      echo "$app was already installed"
      echo ""
    fi
  done
  for app in "${flatpak_apps[@]}"; do
    if ! flatpak list | grep -q $app; then
      flatpak install flathub $app -y --noninteractive
      echo ""
      echo "$app was installed"
      echo ""
    else
      echo ""
      echo "$app was already installed"
      echo ""
    fi
  done
}

function reboot_if_desired() {
  if [ $1 -eq 1 ]; then
    reboot
  fi
}

# EXECUTION #

read -p "Welcome! Choose where you're at:
1. Desktop
2. Laptop

---------> " OPTION

change_hostname "$OPTION"

merge_lists "$OPTION"

update_everything

# Add RPM Fusion repos
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Add WineHQ repo
dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/32/winehq.repo

# Add VSCode repo and install it
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf install code -y -q

# Install Node
curl -sL https://rpm.nodesource.com/setup_lts.x | bash -

# Install Rust's Cargo
curl https://sh.rustup.rs -sSf | sh

update_repos_and_apps

install_apps

# Run Gnome config file
sh ./components/gnome.sh

# Clone GitHub projects
sh ./components/clone_github_projects.sh

# Install Arduino IDE
sh ./components/arduino_ide.sh

update_everything

read -p "Do you want to reboot now?
1. Yes
2. No
---------> "   OPTION1

reboot_if_desired "$OPTION1"