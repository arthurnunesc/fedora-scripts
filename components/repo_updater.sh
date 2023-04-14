#!/usr/bin/env dash

# Clone or update the a repository to a local directory
pkg_repo="$1"
pkg_dir="$2"

if [ "$3" = "master" ]; then
  branch="master"
else
  branch="main"
fi

# Check if the package is already cloned
if [ -d "$pkg_dir" ]; then
  # echo "package was there, trying to pull new changes..."
  :
else
  # echo "package was not there, cloning repository..."
  git clone -q "$pkg_repo" "$pkg_dir"
fi

cd "$pkg_dir" || exit 1

# # Get the current commit hash of the local repository
# current_commit=$(git rev-parse HEAD)
# echo "current commit: $current_commit"

# Pull the latest changes from the remote repository
git pull -q origin "$branch"

# # Get the latest commit hash of the local repository.
# latest_commit=$(git rev-parse HEAD)
# echo "latest commit: $latest_commit"

# # Compare the current commit hash with the latest commit hash.
# if [ "$current_commit" != "$latest_commit" ]; then
#   echo "package update was available, the changes were pulled."
# else
#   echo "package was already up-to-date."
# fi
