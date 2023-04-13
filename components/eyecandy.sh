#!/usr/bin/env dash

# Making sure fonts and icons folders exist to not make them be created as symbolic links and clone eyecandy repo
if [ "$1" = "linux" ]; then
  if [ ! -d "$HOME"/.local/share/fonts ]; then
    mkdir -p "$HOME"/.local/share/fonts
  fi
  sh ./components/repo_updater.sh "https://github.com/arthurnunesc/eyecandy.git" "$HOME/.local/share/fonts"
elif [ "$1" = "mac" ]; then
  if [ ! -d "$HOME"/Library/Fonts ]; then
    mkdir -p "$HOME"/Library/Fonts
  fi
  sh ./components/repo_updater.sh "https://github.com/arthurnunesc/eyecandy.git" "$HOME/Library/Fonts"
fi
