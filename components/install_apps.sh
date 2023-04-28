#!/usr/bin/env sh

### VARIABLES ###

dnf_pkgs_codecs_and_utils="git ssh curl wget ffmpeg fuse-exfat util-linux-user dnf-plugins-core fzf fd-find ripgrep gstreamer1-libav gstreamer1-plugin-openh264 alsa-lib-devel openssl-devel qt5-qtbase qt5-qtbase-gui qt5-qtsvg qt5-qtdeclarative qt5-qtquickcontrols"
dnf_pkgs_gnome_wayland_and_eyecandy="gnome-tweaks dconf-editor rsms-inter-fonts mozilla-fira-sans-fonts libratbag-ratbagd fira-code-fonts jetbrains-mono-fonts ulauncher wmctrl wl-clipboard"
dnf_pkgs_terminal="zsh dash kitty btop neofetch ranger vim-enhanced code"
dnf_pkgs_devops="ansible docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin"
dnf_pkgs_langs="cmake make gcc gcc-c++ go rust cargo python3 python3-pip conda shellcheck devscripts-checkbashisms nodejs java-1.8.0-openjdk java-11-openjdk java-17-openjdk java-latest-openjdk"

flatpak_apps="md.obsidian.Obsidian com.obsproject.Studio com.spotify.Client com.slack.Slack io.github.spacingbat3.webcord com.belmoussaoui.Obfuscate org.gnome.Extensions org.gnome.SoundRecorder org.gnome.Shotwell com.github.tchx84.Flatseal com.transmissionbt.Transmission nl.hjdskes.gcolor3"


### FUNCTIONS ###

update_everything() {
  sudo dnf update -yq > /dev/null 2>&1
  sudo dnf upgrade -yq --refresh > /dev/null 2>&1
  flatpak update -y --noninteractive > /dev/null 2>&1
}

update_repos_and_apps() {
  sudo dnf update -yq > /dev/null 2>&1
  flatpak update -y --noninteractive > /dev/null 2>&1
}

# Takes a string with dnf packages separated by spaces and installs them one by one
install_dnf_pkgs_from_string() {
  installed_dnf_apps=$(dnf list --installed | awk '{print $1}')

  echo "$1" | tr ' ' '\n' | while read -r app; do
    if ! echo "$installed_dnf_apps" | grep -q "$app"; then
      sudo dnf install -yq "$app" > /dev/null 2>&1
      printf "\t\tpackage \033[34m%s\033[0m was installed.\n" "$app"
    else
      printf "\t\tpackage \033[34m%s\033[0m is already installed.\n" "$app" 
    fi
  done
}

# Takes a string with FlatHub inverse domains separated by spaces and installs them
install_flatpak_apps_from_string() {
  installed_flatpak_apps=$(flatpak list)

  echo "$1" | tr ' ' '\n' | while read -r app; do
    if ! echo "$installed_flatpak_apps" | grep -q "$app"; then
      flatpak install flathub -y --noninteractive "$app" > /dev/null 2>&1
      printf "\t\tpackage \033[36m%s\033[0m was installed.\n" "$app"
    else
      printf "\t\tpackage \033[36m%s\033[0m is already installed.\n" "$app" 
    fi
  done
}

### EXECUTION ###

printf "\t- adding repos...\n"
# Add RPMFusion repos
sudo dnf install -yq https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm > /dev/null 2>&1

# Add VSCode repo
sudo rpm --quiet --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Remove previous Docker versions and add its repo
# sudo dnf remove -yq docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine > /dev/null 2>&1
sudo dnf config-manager -yq --add-repo https://download.docker.com/linux/fedora/docker-ce.repo > /dev/null 2>&1

# Add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo > /dev/null 2>&1
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo > /dev/null 2>&1

printf "\t- updating everything...\n"
update_everything

printf "\n\t\033[34m[ dnf - start ]\033[0m\n"
printf "\t- installing codecs, utils and dependencies...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_codecs_and_utils"
sudo dnf install -yq gstreamer1-plugins-good gstreamer1-plugins-base --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf groupinstall -yq "Development Tools"
sudo dnf install -yq lame\* --exclude=lame-devel
sudo dnf group upgrade -yq --with-optional Multimedia
printf "\t- installing packages related to gnome, wayland and eyecandy...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_gnome_wayland_and_eyecandy"
printf "\t- installing terminal related packages...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_terminal"
printf "\t- installing devops tools...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_devops"
printf "\t- installing languages envs and their packages managers...\n"
install_dnf_pkgs_from_string "$dnf_pkgs_langs"
printf "\t\033[34m[ dnf - end ]\033[0m\n"

printf "\n\t - installing flatpak apps...\n"
install_flatpak_apps_from_string "$flatpak_apps"


# Make ulauncher start on boot
systemctl --user enable --now ulauncher

# Installing chezmoi on user binaries folder
if [ -f "$HOME/.local/bin/chezmoi" ]; then
  printf "\t\tpackage chezmoi is already installed.\n"
else
  printf "\t\tinstalling chezmoi.\n"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
fi

# Install neovim as an appimage
if [ -f "$HOME/.local/bin/nvim.appimage" ]; then
  printf "\t\tpackage neovim is already installed.\n"
else
  printf "\t\tinstalling neovim...\n"
  wget -q https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -O "$HOME"/.local/bin/nvim.appimage
fi

if [ -f "$HOME/.local/bin/sspt" ]; then
  printf "\t\tscript sspt is already in user bin folder.\n"
else
  cp ./scripts/spotify-tui/sspt "$HOME"/.local/bin/sspt
  printf "\t\tscript sspt was copied to the user bin folder.\n"
fi
