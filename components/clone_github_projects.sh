#!/usr/bin/env bash

github_projects_links=(
  https://github.com/arthurnunesc/postinstall-fedora.git
  https://github.com/arthurnunesc/arthurnunesc.github.io.git
  https://github.com/arthurnunesc/blog-posts.git
  https://github.com/arthurnunesc/ansible.git
)

if [ ! -d "$HOME/Projects" ]; then
  mkdir $HOME/Projects
fi
cd $HOME/Projects
for link in "${github_projects_links[@]}"; do
  git clone $link
done
cd