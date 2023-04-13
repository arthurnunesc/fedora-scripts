#!/usr/bin/env dash

# Checks which OS we are in and sets the machine variable accordingly
uname_out="$(uname -s)"
case "${uname_out}" in
Linux*) machine=linux ;;
Darwin*) machine=mac ;;
*) machine="OTHER:${uname_out}" ;;
esac

echo "welcome! you are in a $machine system, starting now."

if [ "$1" = "install and config" ]; then
  sh ./install.sh "$machine"
  sh ./config.sh "$machine"
elif [ "$1" = "install" ]; then
  sh ./install.sh "$machine"
elif [ "$1" = "config" ]; then
  sh ./config.sh "$machine"
fi

echo ""
read -rp "do you want to reboot the system now? [y/N] " OPTION
if [ "$OPTION" = 'y' ] || [ "$OPTION" = 'Y' ]; then
  sudo reboot
fi
