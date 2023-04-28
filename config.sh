#!/usr/bin/env sh

printf "\t- running linux config files...\n"
printf "\t- configuring gnome...\n"
sh ./components/gnome.sh
printf "\t- configuring python...\n"
sh ./components/python.sh
printf "\t- installing rust apps...\n"
sh ./components/rust.sh
printf "\t- configuring git variables...\n"
sh ./components/git.sh
printf "\t- syncing dotfiles...\n"
sh ./components/dotfiles.sh
# printf "\t- cloning eyecandy..."
# sh ./components/eyecandy.sh "$machine"
printf "\t- setting zsh as default shell...\n"
if [ "$SHELL" != "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi