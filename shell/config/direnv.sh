if which direnv &> /dev/null; then
  eval "$(direnv hook $SHELL)"

  _direnv_hook() {
    eval "$(
      (
        (
          direnv export "$SHELL" 2>&1 >&3 |
            egrep -v -e '^direnv: (loading|export|unloading)'
        ) >&2 3>&1
      )
    )"
  };
fi
