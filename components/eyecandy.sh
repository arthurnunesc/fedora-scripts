#!/usr/bin/env sh

# Making sure fonts and icons folders exist to not make them be created as symbolic links and clone eyecandy repo
if [ ! -d "$HOME"/.local/share/fonts ]; then
  mkdir -p "$HOME"/.local/share/fonts
fi
sh ./components/repo_updater.sh "https://github.com/arthurnunesc/eyecandy.git" "$HOME/.local/share/fonts"