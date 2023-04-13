#!/usr/bin/env dash

machine=$1

if [ "$machine" = "linux" ]; then
  echo "running linux config files now."
  echo "configuring gnome..."
  sh ./components/gnome.sh
  echo "configuring python..."
  sh ./components/python.sh
  echo "installing rust apps..."
  sh ./components/rust.sh
  echo "configuring git variables..."
  sh ./components/git.sh
  echo "syncing dotfiles..."
  sh ./components/dotfiles.sh
  # echo "cloning eyecandy..."
  # sh ./components/eyecandy.sh "$machine"
  echo "setting zsh as default shell..."
  if [ "$SHELL" != "/bin/zsh" ]; then
    chsh -s /bin/zsh
  fi
elif [ "$machine" = "mac" ]; then
  echo "running macos config files now."
  echo "configuring python..."
  sh ./components/python.sh
  echo "configuring git variables..."
  sh ./components/git.sh
  echo "syncing dotfiles..."
  sh ./components/dotfiles.sh
  # echo "cloning eyecandy..."
  # sh ./components/eyecandy.sh "$machine"
fi
