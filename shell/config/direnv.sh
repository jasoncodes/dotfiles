if which direnv &> /dev/null; then
  eval "$(direnv hook $SHELL)"

  _direnv_hook() {
    eval "$(
      (
        (
          direnv export "$SHELL" 3>&1 1>&2 2>&3 3>&- |
            egrep -v -e '^direnv: (loading|export|unloading)'
        ) 3>&1 1>&2 2>&3 3>&-
      )
    )"
  };
fi
