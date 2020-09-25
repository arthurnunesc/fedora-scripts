#!/usr/bin/env bash

# VARIABLES #

USER="arthur"
HOSTNAME="localhost"
HOSTNAME_DESKTOP="fedora-desktop"
HOSTNAME_LAPTOP="fedora-laptop"

APPS_DNF=(
  ffmpeg
  htop
  gnome-tweaks
  https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm # Google Chrome browser
  chrome-gnome-shell
  flameshot
  neofetch
  nautilus-dropbox
  code
  https://release.axocdn.com/linux/gitkraken-amd64.rpm # GitKraken
  winehq-staging
  gcc-c++ make # NodeJS build tools
  python-psutil # Ansible dconf dependency
  mozilla-fira-sans-fonts
  mozilla-fira-mono-fonts
)
APPS_DNF_DESKTOP=(
  piper
  lutris
  steam
)

APPS_FLATPAK=(
  org.gimp.GIMP
  com.spotify.Client # non-official
  com.discordapp.Discord # non-official
)
APPS_FLATPAK_DESKTOP=(
)

# TESTS #


# FUNCTIONS #

function change_hostname() {
  if [ $1 -eq 1 ]; then
    HOSTNAME="$HOSTNAME_DESKTOP"
  elif [ $1 -eq 2 ]; then
    HOSTNAME="$HOSTNAME_LAPTOP"
  fi
  hostnamectl set-hostname "$HOSTNAME"
}

function merge_lists() {
  if [ $1 -eq 1 ]; then
  for app in "${APPS_DNF_DESKTOP[@]}"; do
    APPS_DNF+=("$app")
  done
  for app in "${APPS_FLATPAK_DESKTOP[@]}"; do
    APPS_FLATPAK+=("$app")
  done
  fi
}

function update_everything {
  dnf check-update -y
  dnf upgrade --refresh -y
}

function update_repos_and_apps {
  dnf check-update -y
  flatpak update -y
}

function install_apps() {
  local package_type="$1"
  shift
  local arr=("$@")
  if [[ "$package_type" = "dnf" ]]; then
      for app in "${arr[@]}"; do
        if ! dnf list --installed | grep -q $app; then
          dnf install $app -y
          echo "+------------------------------------------------------------------+"
          echo "[JUST INSTALLED] - $app"
          echo "+------------------------------------------------------------------+"
        else
          echo "+------------------------------------------------------------------+"
          echo "[ALREADY INSTALLED] - $app"
          echo "+------------------------------------------------------------------+"
        fi
      done
  elif [[ "$package_type" = "flatpak" ]]; then
    for app in "${arr[@]}"; do
      flatpak install flathub $app -y
      echo "+------------------------------------------------------------------+"
      echo "[INSTALLED] - $app"
      echo "+------------------------------------------------------------------+"
    done
  fi
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
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Add WineHQ repo
dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/32/winehq.repo

# Add VSCode repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Install Node
curl -sL https://rpm.nodesource.com/setup_14.x | bash -

update_repos_and_apps

install_apps dnf "${APPS_DNF[@]}"

install_apps flatpak "${APPS_FLATPAK[@]}"

update_repos_and_apps

read -p "Do you want to reboot now?
1. Yes
2. No
---------> "   OPTION1

reboot_if_desired "$OPTION1"