#!/usr/bin/env bash

# VARIABLES #

hostname="fedora"
hostname_desktop="fedora-desktop"
hostname_laptop="fedora-laptop"

dnf_apps=(
  ffmpeg gstreamer1-libav util-linux-user fuse-exfat dnf-plugins-core fd-find ripgrep openssl-devel curl wget git
  gnome-tweaks dconf-editor
  rsms-inter-fonts levien-inconsolata-fonts cascadia-code-fonts mozilla-fira-sans-fonts jetbrains-mono-fonts piper libratbag-ratbagd
  zsh dash kitty stow btop neofetch ranger spotify-tui
  wmctrl wl-clipboard
  code vim-enhanced shellcheck devscripts-checkbashisms
  python3 python3-pip rust cargo java-1.8.0-openjdk java-11-openjdk java-17-openjdk java-latest-openjdk nodejs
  docker docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin docker-machine
)
dnf_apps_desktop_only=(
)

flatpak_apps=(
  # org.mozilla.firefox
  md.obsidian.Obsidian
  com.transmissionbt.Transmission
  org.gnome.Extensions
  org.gnome.SoundRecorder
  org.gnome.Shotwell # Outdated runtime
  org.gimp.GIMP
  org.gabmus.hydrapaper # Outdated runtime
  nl.hjdskes.gcolor3
  com.github.tchx84.Flatseal
  com.belmoussaoui.Obfuscate
  com.obsproject.Studio
  com.spotify.Client
  io.github.spacingbat3.webcord # Discord client that supports Wayland screensharing
)
flatpak_apps_desktop_only=(
  org.gnome.Boxes
  org.desmume.DeSmuME
  net.lutris.Lutris
  com.valvesoftware.Steam
)

# TESTS #

# FUNCTIONS #

change_hostname() {
  if [ "$1" -eq 1 ]; then
      hostname="$hostname_desktop"
  elif [ "$1" -eq 2 ]; then
    hostname="$hostname_laptop"
  fi
  sudo hostnamectl set-hostname "$hostname"
}

merge_lists() {
  if [ "$1" -eq 1 ]; then
    for app in "${dnf_apps_desktop_only[@]}"; do
      dnf_apps+=("$app")
    done
    for app in "${flatpak_apps_desktop_only[@]}"; do
      flatpak_apps+=("$app")
    done
  fi
}

update_everything() {
  sudo dnf update -yq
  sudo dnf upgrade --refresh -yq
  flatpak update -y --noninteractive
}

update_repos_and_apps() {
  sudo dnf update -yq
  flatpak update -y --noninteractive
}

install_apps() {
  for app in "${dnf_apps[@]}"; do
    if ! sudo dnf list --installed | grep -q "$app"; then
      sudo dnf install "$app" -yq
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

reboot_if_desired() {
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
sudo rpm --import --quiet https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Add RPM Fusion free and nonfree repos
sudo dnf -yq install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

# Add spotify-tui repo (Spotify CLI)
sudo dnf copr enable atim/spotify-tui -y

# Remove previous Docker versions and add its repo
sudo dnf -yq remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine
sudo dnf -yq config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

update_repos_and_apps

install_apps

# Install neovim as a appimage
wget -q https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -O "$HOME"/.local/bin/nvim.appimage

# Update pip before installing everything
pip install --upgrade pip

# Installs TLDR
pip install -q tldr

# Installs 42 Norminette
pip install --upgrade pip setuptools
pip install norminette
pip install --upgrade norminette

# Install ruff-lsp to use on neovim
pip install ruff-lsp

# Installs black for Python code formatting
pip install black pynvim
pip install "black[jupyter]"

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
---------> " OPTION1

reboot_if_desired "$OPTION1"
