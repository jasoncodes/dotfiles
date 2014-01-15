tmux() {
  if [[ $# -eq 0 ]]; then
    command tmux attach || command tmux
  else
    command tmux "$@"
  fi
}
