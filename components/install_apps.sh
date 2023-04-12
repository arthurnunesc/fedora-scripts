#!/usr/bin/env bash

# VARIABLES #

dnf_apps=(
  ffmpeg gstreamer1-libav util-linux-user fuse-exfat dnf-plugins-core fd-find ripgrep ansible alsa-lib-devel openssl-devel curl wget git ssh
  gnome-tweaks dconf-editor
  rsms-inter-fonts mozilla-fira-sans-fonts
  libratbag-ratbagd
  zsh dash kitty stow btop neofetch ranger ulauncher
  wmctrl wl-clipboard
  code vim-enhanced shellcheck devscripts-checkbashisms
  python3 python3-pip make gcc go rust cargo java-1.8.0-openjdk java-11-openjdk java-17-openjdk java-latest-openjdk nodejs
  docker docker-ce docker-ce-cli 'containerd.io' docker-buildx-plugin docker-compose docker-compose-plugin
)

flatpak_apps=(
  md.obsidian.Obsidian
  com.transmissionbt.Transmission
  org.gnome.Extensions
  org.gnome.SoundRecorder
  org.gnome.Shotwell # Outdated runtime
  org.gimp.GIMP
  nl.hjdskes.gcolor3
  com.github.tchx84.Flatseal
  com.belmoussaoui.Obfuscate
  com.obsproject.Studio
  com.spotify.Client
  com.slack.Slack
  io.github.spacingbat3.webcord # Discord client that supports Wayland screensharing
)

installed_apps="$(flatpak list) $(dnf list --installed | awk '{print $1}')"

# TESTS #

# FUNCTIONS #

update_everything() {
  sudo dnf update -yq
  sudo dnf upgrade -yq --refresh
  flatpak update -y --noninteractive
}

update_repos_and_apps() {
  sudo dnf update -yq
  flatpak update -y --noninteractive
}

install_apps() {
  for app in "${dnf_apps[@]}"; do
    if ! echo "$installed_apps" | grep -q "$app"; then
      sudo dnf install -yq "$app"
      echo "package $app was installed."
    else
      echo "package $app is already installed."
    fi
  done

  for app in "${flatpak_apps[@]}"; do
    if ! echo "$installed_apps" | grep -q "$app"; then
      flatpak install flathub -y --noninteractive "$app"
      echo "package $app was installed."
    else
      echo "package $app is already installed."
    fi
  done
}

# EXECUTION

# Add RPMFusion repos
sudo dnf install -yq https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

# Add VSCode repo
sudo rpm --quiet --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Remove previous Docker versions and add its repo
sudo dnf remove -yq docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine
sudo dnf config-manager -yq --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

update_everything

install_apps

# Install neovim as a appimage
if [ -f "$HOME/.local/bin/nvim.appimage" ]; then
  echo "package neovim is already installed."
else
  wget -q https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -O "$HOME"/.local/bin/nvim.appimage
fi
