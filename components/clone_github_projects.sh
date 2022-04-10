#!/usr/bin/env bash

github_projects_links=(
  https://github.com/arthurnunesc/fedora-postinstall.git
  https://github.com/arthurnunesc/text-analyser.git
  https://github.com/arthurnunesc/arthurnunesc.github.io.git
  https://github.com/arthurnunesc/blog-posts.git
)

if [ ! -d "$HOME/Projects" ]; then
  mkdir "$HOME"/Projects
fi
cd "$HOME"/Projects || return
for link in "${github_projects_links[@]}"; do
  git clone "$link"
done
cd || return