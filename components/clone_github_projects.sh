#!/usr/bin/env bash

github_projects_links=(
  https://github.com/arthurnunesc/arthurnunesc.github.io.git
  https://github.com/arthurnunesc/postinstall-fedora.git
  https://github.com/arthurnunesc/postinstall-openSUSE.git
  https://github.com/arthurnunesc/ansible.git
)

if [ ! -d "$HOME/Projects" ]; then
  mkdir $HOME/Projects
fi
for link in "${github_projects_links[@]}"; do
  git clone $link $HOME/Projects
done