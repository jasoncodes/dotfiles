_direnv_hook() {
  eval "$(
    (
      (
        direnv export bash 3>&1 1>&2 2>&3 3>&- |
          egrep -v -e '^direnv: (loading|export|unloading)'
      ) 3>&1 1>&2 2>&3 3>&-
    )
  )"
};

if ! [[ "$PROMPT_COMMAND" =~ _direnv_hook ]]; then
  PROMPT_COMMAND="_direnv_hook;$PROMPT_COMMAND";
fi
