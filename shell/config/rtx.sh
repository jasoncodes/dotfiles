# brew install rtx
# rtx install

if command -v rtx > /dev/null; then
  if [[ -n "${BASH_VERSION:-}" ]]; then
    eval "$(rtx activate bash)"
  fi
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    eval "$(rtx activate zsh)"
  fi
fi
