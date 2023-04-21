#!/usr/bin/env sh

rm -rf "$HOME"/.zshrc

# Clones dotfiles from my GitHub repo
sh ./components/repo_updater.sh "https://github.com/arthurnunesc/dotfiles.git" "$HOME/.dotfiles"

# Synchronizes all dotfiles with stow
cd "$HOME"/.dotfiles || exit 1
stow */ --target="$HOME"
cd - || exit 1
