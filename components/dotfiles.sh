#!/usr/bin/env dash

# Clones zsh-syntax-highlighting plugin into .config
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.config/zsh/plugins/zsh-syntax-highlighting

# Clones dotfiles from my GitHub repo
git clone https://github.com/arthurnunesc/dotfiles.git "$HOME"/.dotfiles

# Making sure fonts and icons folders exist to not make them be created as symbolic links
if [ "$1" = "linux" ]; then
  if [ ! -d "$HOME"/.local/share/fonts ]; then
    mkdir -p "$HOME"/.local/share/fonts
  fi
  if [ ! -d "$HOME"/.local/share/icons ]; then
    mkdir -p "$HOME"/.local/share/icons
  fi
else
  if [ ! -d "$HOME"/Library/Fonts ]; then
    mkdir -p "$HOME"/Library/Fonts
  fi
fi

# Synchronizes all dotfiles with stow
cd "$HOME"/.dotfiles || return
stow */
cd || return
