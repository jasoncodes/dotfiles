if [ -t 0 ]; then
  trap '{ echo -n "^C" >&2; }' SIGINT
  stty -echoctl
fi
