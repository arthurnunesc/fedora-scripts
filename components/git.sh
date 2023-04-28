#!/usr/bin/env sh

printf "\t- configuring git variables...\n"

git config --global user.email "arthurnunesc@proton.me"
git config --global user.name "Arthur Nunes"
git config --global core.editor "nvim"

# Create Projects folder
if [ ! -d "$HOME/Projects" ]; then
  mkdir "$HOME"/Projects
fi