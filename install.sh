#!/usr/bin/env sh

printf "\t- changing remote configurations to make downloads faster...\n"
sh ./components/fedora.sh
sh ./components/install_apps.sh
