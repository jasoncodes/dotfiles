# requires:
#
#   fresh jasoncodes/dotfiles shell/functions/realpath.sh

function first_file_match()
{
  local OP="$1"
  shift
  while [ $# -gt 0 ]
  do
    if [ $OP "$1" ]
    then
      echo "$1"
      return 0
    fi
    shift
  done
  return 1
}

if which git &> /dev/null
then
  GIT_COMPLETION_PATH="$(dirname $(realpath "$(which git)"))/../etc/bash_completion.d/git-completion.bash"
fi
if [ ! -f "$GIT_COMPLETION_PATH" ]
then
  GIT_COMPLETION_PATH=$(first_file_match -f \
    "/usr/local/git/contrib/completion/git-completion.bash" \
    "/opt/local/share/doc/git-core/contrib/completion/git-completion.bash" \
    "/etc/bash_completion.d/git" \
  )
fi
if [ -f "$GIT_COMPLETION_PATH" ]
then
  source "$GIT_COMPLETION_PATH"
  GIT_PROMPT_PATH="$(dirname "$GIT_COMPLETION_PATH")/git-prompt.sh"
  if [ -f "$GIT_PROMPT_PATH" ]; then
    source "$GIT_PROMPT_PATH"
  fi

  _git_complete() {
    local CMD="$1"
    shift
    if type __git_complete &>/dev/null; then
      for ALIAS in "$@"; do
        __git_complete "$ALIAS" "_git_$CMD"
      done
    else
      complete -o bashdefault -o default -o nospace -F "_git_$CMD" "$@"
    fi
  }

  _git_complete log gl glp gls glw
  _git_complete checkout gco gcp
  _git_complete status gs
  _git_complete diff gd gdw gds gdsw
  _git_complete reset gar garp
  _git_complete add ga gap
  _git_complete commit gc gca
  _git_complete push gp
fi
