wemux() {
  if which wemux-start &> /dev/null; then
    command wemux-start "$@"
  else
    command wemux "$@"
  fi
}
