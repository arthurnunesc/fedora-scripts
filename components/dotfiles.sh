#!/usr/bin/env dash

# Clones zsh plugins into .config
sh ./components/repo_updater.sh "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.config/zsh/plugins/zsh-syntax-highlighting" "master"
sh ./components/repo_updater.sh "https://github.com/zsh-users/zsh-autosuggestions.git" "$HOME/.config/zsh/plugins/zsh-autosuggestions" "master"
sh ./components/repo_updater.sh "https://github.com/zsh-users/zsh-completions.git" "$HOME/.config/zsh/plugins/zsh-completions" "master"

# Clones dotfiles from my GitHub repo
sh ./components/repo_updater.sh "https://github.com/arthurnunesc/dotfiles.git" "$HOME/.dotfiles"

rm -rf "$HOME"/.zshrc

# Synchronizes all dotfiles with stow
cd "$HOME"/.dotfiles || return
stow */ -t "$HOME"
cd || return
