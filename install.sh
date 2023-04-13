#!/usr/bin/env dash

machine=$1

if [ "$machine" = "linux" ]; then
  echo "changing remote configurations to make downloads faster..."
  sh ./components/fedora.sh
  echo "updating everything and installing apps..."
  sh ./components/install_apps.sh
elif [ "$machine" = "mac" ]; then
  echo "there is nothing to install on mac systems."
fi
