#!/usr/bin/env dash

pip3_apps="pip setuptools tldr norminette ruff-lsp black pynvim black[jupyter] black[d]"

if [ ! -d "$HOME"/.local/venv/nvim ]; then
  mkdir -p "$HOME"/.local/venv && cd "$HOME"/.local/venv || return
  python3 -m venv nvim
  cd nvim || return
  . ./bin/activate
  pip3 install -Uq pynvim black
  cd || return
fi

echo "$pip3_apps" | tr ' ' '\n' | while read -r item; do
  pip3 install -Uq "$item"
done

# sh ./components/conda-auto-install.sh
