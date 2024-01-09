# brew install mise
# mise install

if command -v mise > /dev/null; then
  if [[ -n "${BASH_VERSION:-}" ]]; then
    eval "$(mise activate bash)"
  fi
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    eval "$(mise activate zsh)"
  fi
fi
