#!/usr/bin/env bash

github_projects_links=(
  https://github.com/arthurnunesc/arthurnunesc.github.io.git
  https://github.com/arthurnunesc/postinstall-fedora.git
  https://github.com/arthurnunesc/postinstall-openSUSE.git
  https://github.com/arthurnunesc/ansible.git
)

function clone_github_projects {
  if [ ! -d "$HOME/Projects" ]; then
    mkdir $HOME/Projects
  fi
  cd $HOME/Projects
  for link in "${github_projects_links[@]}"; do
    git clone $link
  done
  cd
}

clone_github_projects