#!/usr/bin/env dash

pip_apps="pip setuptools tldr norminette ruff-lsp black pynvim black[jupyter] black[d]"

if [ ! -d "$HOME"/.local/venv/nvim ]; then
  mkdir -p "$HOME"/.local/venv && cd "$HOME"/.local/venv || return
  python3 -m venv nvim
  cd nvim || return
  . ./bin/activate
  pip install -Uq pynvim black
  cd || return
fi


echo "$pip_apps" | tr ' ' '\n' | while read -r item; do
  pip install -Uq "$item"
done