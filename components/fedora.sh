#!/usr/bin/env sh

# Changes Fedora remote configurations so downloads are faster
if grep -Fxq "max_parallel_downloads=10" /etc/dnf/dnf.conf; then
  echo "max_parallel_downloads variable was already set to 10."
else
  echo "Changing Max Parallel Downloads variable to 10..."
  echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
  echo "Done."
fi

if grep -Fxq "fastestmirror=True" /etc/dnf/dnf.conf; then
  echo "fastestmirror variable was already set to True."
else
  echo "Changing Fastest Mirror variable to True..."
  echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
  echo "Done."
fi
