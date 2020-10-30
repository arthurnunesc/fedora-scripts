#!/usr/bin/env bash

# Install MarkText and AppImage Launcher

appimages_download_links=(
  https://github-production-release-asset-2e65be.s3.amazonaws.com/110446844/2a180380-b1e7-11ea-8434-d3ff8818f6a1?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20201027%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201027T214226Z&X-Amz-Expires=300&X-Amz-Signature=12e15ff95facd03541c64570f682759022fb74a520ec097beaf6f6850ab33305&X-Amz-SignedHeaders=host&actor_id=3931980&key_id=0&repo_id=110446844&response-content-disposition=attachment%3B%20filename%3Dmarktext-x86_64.AppImage&response-content-type=application%2Foctet-stream
)

function install_appimages {
  if [ ! -d "$HOME/Applications" ]; then
    mkdir $HOME/Applications
  fi
  cd $HOME/Applications
  for link in "${appimages_download_links[@]}"; do
  done
  cd
}