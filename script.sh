#!/usr/bin/env bash

# VARIABLES #

hostname="localhost"
hostname_desktop="fedora-desktop"
hostname_laptop="fedora-laptop"

dnf_apps=(
    git
    ffmpeg
    gstreamer1-libav
    util-linux-user
    fuse-exfat
    gnome-tweaks
    dconf-editor
    neofetch
    mozilla-fira-sans-fonts
    mozilla-fira-mono-fonts
    rsms-inter-fonts
    jetbrains-mono-fonts
    fira-code-fonts
    piper libratbag-ratbagd
    sway
    zsh
    code
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
    md.obsidian.Obsidian 
    # org.mozilla.firefox
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
        if ! flatpak list | grep -q "$app"; then
        flatpak install flathub "$app" -y --noninteractive
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
    if [ "$1" -eq 1 ]; then
        sudo reboot
    fi
}

# EXECUTION #

read -rp "welcome! what device are you using this script in?
1. desktop
2. laptop

---------> " OPTION

change_hostname "$OPTION"

merge_lists "$OPTION"

update_everything

# Add VSCode repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Add RPM Fusion repos
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y -q

# Add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

update_repos_and_apps

install_apps

# Run Gnome config file
sh ./components/gnome.sh

# Create Projects folder and clone GitHub projects
if [ ! -d "$HOME/Projects" ]; then
  mkdir "$HOME"/Projects
fi
# sh ./components/clone_github_projects.sh

# Set ZSH as default shell
sudo usermod --shell /bin/zsh "$USER"

update_everything

read -rp "do you want to reboot now?
1. yes
2. no

---------> "   OPTION1

reboot_if_desired "$OPTION1"
