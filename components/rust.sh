#!/usr/bin/env sh

printf "\t- installing rust apps with cargo...\n"

cargo install -q spotifyd --locked
cargo install -q spotify-tui
cargo install -q starship --locked
