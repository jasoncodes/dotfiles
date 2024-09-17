tmux() {
  if [[ $# -eq 0 ]]; then
    command tmux new -A
  else
    command tmux "$@"
  fi
}

# https://iterm2.com/documentation-tmux-integration.html
ssh-tmux() {
  if [[ $# -ne 1 ]]; then
    echo "usage: ssh-tmux <host>" >&2
    return 1
  fi

  local host="${1?}"

  ssh -t "$host" "tmux -CC new -A -s 0"
}
