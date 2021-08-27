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
  GIT_BASE_DIR="$(dirname $(realpath "$(which git)") | sed -e 's#/bin##' -e 's#/libexec/git-core##')"
fi

GIT_COMPLETION_PATH=$(first_file_match -f \
  "$GIT_BASE_DIR/etc/bash_completion.d/git-completion.bash" \
  "$GIT_BASE_DIR/share/git/contrib/completion/git-completion.bash" \
  "/usr/local/git/contrib/completion/git-completion.bash" \
  "/opt/local/share/doc/git-core/contrib/completion/git-completion.bash" \
  "/etc/bash_completion.d/git" \
  "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" \
  "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash" \
)

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

  _git_complete log gl glg glp gls glw gbl gblp
  _git_complete checkout gco gcp
  _git_complete status gs
  _git_complete diff gd gdw gbdw gds gdsw gbd
  _git_complete reset gar garp
  _git_complete add ga gap
  _git_complete commit gc gca
  _git_complete push gp
  _git_complete show gsw
fi
