#!/usr/bin/env bash

github_projects_links=(
  https://github.com/arthurnunesc/fedora-postinstall.git
  https://github.com/arthurnunesc/accento.git
  https://github.com/arthurnunesc/arthurnunesc.github.io.git
  https://github.com/arthurnunesc/arthurnunesc-portfolio-website
  https://github.com/arthurnunesc/web-scraper-arabic-flashcards.git
)

cd "$HOME"/Projects || return
for link in "${github_projects_links[@]}"; do
  git clone "$link"
done
cd || return