if which direnv &> /dev/null; then
  eval "$(direnv hook $SHELL)"

  _direnv_hook() {
    eval "$(direnv export zsh 2> >( egrep -v -e '^direnv: (loading|export|unloading)' ))"
  };
fi
