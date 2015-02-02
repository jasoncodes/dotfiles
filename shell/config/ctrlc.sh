_print_ctrl_c() {
  echo -n '^C' >&2
}

if [ -t 0 ]; then
  trap _print_ctrl_c SIGINT
  stty -echoctl
fi
