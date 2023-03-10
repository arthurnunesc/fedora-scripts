#!/usr/bin/env bash

# Clones zsh-syntax-highlighting plugin into .config
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.config/zsh/plugins/zsh-syntax-highlighting

# Clones powerlevel10k to its folder
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/.powerlevel10k

# Clones dotfiles from my GitHub repo
git clone https://github.com/arthurnunesc/dotfiles.git "$HOME"/.dotfiles

# Synchronizes all dotfiles with stow
cd "$HOME"/.dotfiles
stow */
cd
