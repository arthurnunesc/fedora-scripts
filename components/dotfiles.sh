#!/usr/bin/env sh

printf "\t- syncing dotfiles...\n"

# Delete default .zshrc file
rm -rf "$HOME"/.zshrc

# Clones dotfiles from my GitHub repo
"$HOME"/.local/bin/chezmoi init --apply git@github.com:arthurnunesc/dotfiles.git
