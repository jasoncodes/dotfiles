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

# add git status if available
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export PS1="$PS1"'\[\033[01;30m\]$(type __git_ps1 &> /dev/null && __git_ps1 " (%s)")'

# finish off the prompt
export PS1="$PS1"'\[\033[00m\]\$ '
