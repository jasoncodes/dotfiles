export EDITOR='vim'
export BUNDLER_EDITOR='vim'
export GEM_EDITOR='vim'
if [[ "$TERM_PROGRAM" =~ iTerm|Apple_Terminal ]] && [[ -x "`which mvim`" ]]; then
  if [[ -z "$SSH_CONNECTION" ]] && [[ -z "$TMUX" ]]; then
    export BUNDLER_EDITOR='mvim'
    export GEM_EDITOR='mvim'
  fi
fi
