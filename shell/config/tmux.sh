tmux() {
  if [[ $# -eq 0 ]]; then
    command tmux new -A
  else
    command tmux "$@"
  fi
}
