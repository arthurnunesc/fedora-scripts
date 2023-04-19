#!/usr/bin/env dash

# Clones dotfiles from my GitHub repo
sh ./components/repo_updater.sh "https://github.com/arthurnunesc/dotfiles.git" "$HOME/.dotfiles"

rm -rf "$HOME"/.zshrc

# Synchronizes all dotfiles with stow
cd "$HOME"/.dotfiles || exit 1
stow */ -t "$HOME"
cd - || exit 1
