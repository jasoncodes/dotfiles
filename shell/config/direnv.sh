if which direnv &> /dev/null; then
  eval "$(direnv hook $0)"
fi
