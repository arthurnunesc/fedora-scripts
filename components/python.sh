#!/usr/bin/env dash

pip_apps="pip setuptools tldr norminette ruff-lsp black pynvim black[jupyter] black[d]"

mkdir -p ~/.local/venv && cd ~/.local/venv || return
python3 -m venv nvim
cd nvim || return
. ./bin/activate
pip install pynvim black
cd || return

echo "$pip_apps" | tr ' ' '\n' | while read -r item; do
  pip install -Uq "$item"
done