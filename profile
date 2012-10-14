source ~/.fresh/build/shell.sh

# locale stuff
export LANG=en_AU.UTF-8
export LC_CTYPE=en_US.UTF-8

# general shell settings
export PS1='\u@\h:\w\$ ' # basic prompt. get's overwritten later
export FIGNORE="CVS:.DS_Store:.svn:__Alfresco.url"
export EDITOR='vim'
if [[ "$TERM_PROGRAM" =~ iTerm|Apple_Terminal ]] && [[ -x "`which mvim`" ]]; then
  export BUNDLER_EDITOR='mvim'
  export GEM_EDITOR='mvim'
fi
alias less='less -iM'
export PAGER='less -SFXiM'
export MAKEFLAGS='-j 3'
complete -d cd mkdir rmdir

# set CVS to use :ext: via SSH (preferring ssh-master if available)
if [ -x "`which ssh-master`" ]
then
  export CVS_RSH=ssh-master
else
  export CVS_RSH=ssh
fi

# open man pages in Preview.app
if [ -d "/Applications/Preview.app" ]
then
  pman () {
    man -t "$@" |
    ( which ps2pdf > /dev/null && ps2pdf - - || cat) |
    open -f -a /Applications/Preview.app
  }
fi

# our own bin dir at the highest priority, followed by /usr/local/bin
export PATH=~/bin:/usr/local/bin:/usr/local/sbin:"$PATH"

# add a poor facsimile for Linux's `free` if we're on Mac OS
if ! type free > /dev/null 2>&1 && [[ "$(uname -s)" == 'Darwin' ]]
then
  alias free="top -s 0 -l 1 -pid 0 -stats pid | grep '^PhysMem: ' | cut -d : -f 2- | tr ',' '\n'"
fi

# I love colour
if ls --version 2> /dev/null | grep -q 'GNU coreutils'
then
  export GREP_OPTIONS='--color=auto'
  alias ls="ls --color=auto --classify --block-size=\'1"
fi
alias dir='echo Use /bin/ls :\) >&2; false' # I used this to ween myself away from the 'dir' alias
alias mate='echo Use mvim :\) >&2; false'
alias nano='echo Use vim :\) >&2; false'
function rake
{
  if [ -S .zeus.sock ]; then
    zeus rake "$@"
  elif [ -f Gemfile ]; then
    bundle exec rake "$@"
  else
    "$(/usr/bin/which rake)" "$@"
  fi
}

# handy aliases
alias timestamp='gawk "{now=strftime(\"%F %T \"); print now \$0; fflush(); }"'

# awesome history tracking
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
export PROMPT_COMMAND='history -a'
shopt -s histappend
PROMPT_COMMAND='history -a; echo "$$ $USER $(history 1)" >> ~/.bash_eternal_history'

# notify of bg job completion immediately
set -o notify

# use Vi mode instead of Emacs mode
set -o vi

# no mail notifications
shopt -u mailwarn
unset MAILCHECK

# check for window resizing whenever the prompt is displayed
shopt -s checkwinsize
# display "user@hostname: dir" in the window title
if [[ "$TERM" =~ ^xterm ]]
then
  export PROMPT_COMMAND="$PROMPT_COMMAND; "'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
fi

# enable rvm if available
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]]; then
  source "/usr/local/rvm/scripts/rvm"
fi
[[ -n "$rvm_path" ]] && [[ -r "$rvm_path/scripts/completion" ]] && source "$rvm_path/scripts/completion"
export rvm_pretty_print_flag=1

# set JAVA_HOME if on Mac OS
if [ -z "$JAVA_HOME" -a -d /System/Library/Frameworks/JavaVM.framework/Home ]
then
  export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
fi

# lesspipe lets us do cool things like view gzipped files
if [ -x "`which lesspipe`" ]
then
  eval "$(lesspipe)"
elif [ -x "`which lesspipe.sh`" ]
then
  eval "$(lesspipe.sh)"
fi

# alias Debian's `ack-grep` to `ack`
if type -t ack-grep > /dev/null
then
  alias ack=ack-grep
fi

# load Homebrew's shell completion
if which brew > /dev/null && [ -f "$(brew --prefix)/Library/Contributions/brew_bash_completion.sh" ]
then
  source "$(brew --prefix)/Library/Contributions/brew_bash_completion.sh"
fi

# `vimlast` opens the last modified file in Vim.
vimlast() {
  if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    local EDITOR=mvim
  fi
  FILE=$(
    /usr/bin/find ${1:-.} -type f \
      -not -regex '\./\..*' \
      -not -regex '\./tmp/.*' \
      -not -regex '\./log/.*' \
      -exec stat -c '%Y %n' {} +\; |
    sort -n | tail -1 | cut -d ' ' -f 2-
  )
  ${EDITOR:-vim} $FILE
}

# http://github.com/therubymug/hitch
hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'

# filters for XML and JSON
alias xml='xmllint -format - | pygmentize -l xml'
alias json='python -mjson.tool | coderay -json'

# be able to 'cd' into SMB URLs
# requires <http://github.com/jasoncodes/scripts/blob/master/smburl_to_path>
function cd_smburl()
{
  cd "`smburl_to_path "$1"`"
}

# begin awesome colour prompt..
export PS1=""

# add rvm version@gemset
if [[ -n "$rvm_path" ]]
then
  function __my_rvm_ps1()
  {
    [[ -z "$rvm_ruby_string" ]] && return
    if [[ -z "$rvm_gemset_name" && "$rvm_sticky_flag" -ne 1 ]]
    then
      [[ "$rvm_ruby_string" = "system" ]] && echo "system " && return
      grep -q -F "default=$rvm_ruby_string" "$rvm_path/config/alias" && return
    fi
    local full=$(
      "$rvm_path/bin/rvm-prompt" i v p g s |
      sed \
        -e 's/jruby-jruby-/jruby-/' -e 's/ruby-//' \
        -e 's/-head/H/' \
        -e 's/-2[0-9][0-9][0-9]\.[0-9][0-9]//' \
        -e 's/-@/@/' -e 's/-$//')
    [ -n "$full" ] && echo "$full "
  }
  export PS1="$PS1"'\[\033[01;30m\]$(__my_rvm_ps1)'
fi

# add user@host:path
export PS1="$PS1\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w"

function realpath()
{
  python -c 'import os,sys;print os.path.realpath(sys.argv[1])' "$@"
}

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

# add git status if available
if which git > /dev/null
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
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export PS1="$PS1"'\[\033[01;30m\]$(__git_ps1 " (%s)")'
  complete -o bashdefault -o default -o nospace -F _git_log gl glp gls glw
  complete -o bashdefault -o default -o nospace -F _git_checkout gco gcp
  complete -o bashdefault -o default -o nospace -F _git_status gst
  complete -o bashdefault -o default -o nospace -F _git_diff gd gdw gds gdsw
  complete -o bashdefault -o default -o nospace -F _git_reset gar garp
  complete -o bashdefault -o default -o nospace -F _git_add gap
  complete -o bashdefault -o default -o nospace -F _git_commit gc gca
  complete -o bashdefault -o default -o nospace -F _git_push gp
  source ~/.dotfiles/git-flow-completion.bash
fi

# finish off the prompt
export PS1="$PS1"'\[\033[00m\]\$ '

# initialise rbenv
if [[ -x "`which rbenv`" ]]; then
  eval "$(rbenv init - --no-rehash)"
fi

# initialise autojump
AUTOJUMP_SCRIPT="$(brew --prefix)/etc/autojump"
if [ -e "$AUTOJUMP_SCRIPT" ]
then
  source "$AUTOJUMP_SCRIPT"
fi

# load local shell configuration if present
if [[ -f ~/.bashrc.local ]]
then
   source ~/.bashrc.local
fi
