#!/usr/bin/env bash

# VARIABLES #

USER="arthur"
HOSTNAME="localhost"
HOSTNAME_DESKTOP="fedora-desktop"
HOSTNAME_LAPTOP="fedora-laptop"

APPS_DNF=(
  ffmpeg
  gstreamer1-libav
  htop
  flameshot
  neofetch
  gnome-tweaks
  mozilla-fira-sans-fonts
  mozilla-fira-mono-fonts
  https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm # Google Chrome browser
  chrome-gnome-shell # For installing Gnome extensions via Chrome
  nautilus-dropbox
  code
  alacritty
  https://release.axocdn.com/linux/gitkraken-amd64.rpm # GitKraken
  winehq-staging
  gcc-c++ make # NodeJS build tools
  python-psutil # Ansible dconf dependency
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
  org.libreoffice.LibreOffice # non-official
)
APPS_FLATPAK_DESKTOP=(
)

PROJECT_LINKS=(
  https://github.com/arthurnunesc/arthurnunesc.github.io.git
  https://github.com/arthurnunesc/blog-posts.git
  https://github.com/arthurnunesc/arthurnunesc.git
  https://github.com/arthurnunesc/postinstall-fedora.git
  https://github.com/arthurnunesc/postinstall-popos.git
  https://github.com/arthurnunesc/ansible.git
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
  if [[ "$1" = "dnf" ]]; then
      for app in "${APPS_DNF[@]}"; do
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
  elif [[ "$1" = "flatpak" ]]; then
    for app in "${APPS_FLATPAK[@]}"; do
      flatpak install flathub $app -y
      echo "+------------------------------------------------------------------+"
      echo "[INSTALLED] - $app"
      echo "+------------------------------------------------------------------+"
    done
  fi
}

function clone_repos {
  if [ ! -d "/home/$MY_USER/Projects" ]; then
    mkdir /home/$MY_USER/Projects
  fi
  cd /home/$MY_USER/Projects
  for link in "${PROJECT_LINKS[@]}"; do
    git clone $link
  done
  cd
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

# Add Alacritty repo
dnf copr enable pschyska/alacritty

# Install Node
curl -sL https://rpm.nodesource.com/setup_14.x | bash -

update_repos_and_apps

install_apps dnf

install_apps flatpak

clone_repos

update_repos_and_apps

read -p "Do you want to reboot now?
1. Yes
2. No
---------> "   OPTION1

reboot_if_desired "$OPTION1"