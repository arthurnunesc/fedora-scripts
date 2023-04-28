#!/usr/bin/env sh

printf "\t- changing remote configurations to make downloads faster...\n"
dash ./components/fedora.sh
dash ./components/install_apps.sh
