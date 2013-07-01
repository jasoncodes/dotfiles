trap '{ echo -n "^C" >&2; }' SIGINT
stty -echoctl
