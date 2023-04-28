#!/usr/bin/env sh

printf "\t- changing remote configurations to make downloads faster...\n"

# Changes Fedora remote configurations so downloads are faster
if grep -Fxq "max_parallel_downloads=10" /etc/dnf/dnf.conf; then
  printf "\t\tmax_parallel_downloads variable was already set to 10.\n"
else
  printf "\t\tchanging max_parallel_downloads variable to 10...\n"
  echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
  printf "\t\tdone.\n"
fi

if grep -Fxq "fastestmirror=True" /etc/dnf/dnf.conf; then
  printf "\t\tfastestmirror variable was already set to True.\n"
else
  printf "\t\tchanging fastestmirror variable to True...\n"
  echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
  printf "\t\tdone.\n"
fi
