alias zs='zeus start'
alias ss='bin/spring server'
alias rails=rails_command
alias rc='rails console'
alias rs='rails server'
alias rgm='rails generate migration'

zeus() {
  command zeus "$@"
  RETVAL=$?
  stty sane
  return $RETVAL
}

function rails_command
{
  local cmd=$1
  shift

  if [ -S .zeus.sock ]; then
    zeus "$cmd" "$@"
  elif [ -e bin/rails ]; then
    bin/rails "$cmd" "$@"
  elif [ -e script/rails ]; then
    script/rails "$cmd" "$@"
  elif [ -e "script/$cmd" ]; then
    "script/$cmd" "$@"
  else
    command rails "$cmd" "$@"
  fi
}

function rspec {
  if [ -S .zeus.sock ]; then
    local CMD='zeus rspec'
  elif [ -x bin/rspec ]; then
    local CMD='bin/rspec'
  else
    local CMD='bundle exec rspec'
  fi
  if [[ $# == 0 ]]; then
    set -- spec "$@"
  fi
  (
    [ -n "${ZSH_VERSION:-}" ] && setopt shwordsplit
    exec $CMD --color "$@"
  )
}
alias rspec-doc='rspec --format=doc'

function _resolve_spec_files() {
  sed -e 's#^app/##' -e 's#^\([^.]*\)\..*$#spec/\1_spec.rb#' -e 's#^spec/\(spec/.*\)_spec\(_spec\.rb\)$#\1\2#' |
  grep '_spec\.rb$' |
  sort -u |
  xargs find 2> /dev/null
}

function rspec-branch {
  FILES="$(git diff $(git merge-base origin/HEAD HEAD).. --name-only | _resolve_spec_files)"
  if [ -z "$FILES" ]; then
    echo rspec-branch: no changes to test >&2
    return 1
  fi
  if [ -d spec/ratchets ]; then
    FILES="$FILES spec/ratchets"
  fi
  (
    [ -n "${ZSH_VERSION:-}" ] && setopt shwordsplit
    rspec $FILES "$@"
  )
}
alias rspec-branch-doc='rspec-branch -f doc'

function rspec-work {
  FILES="$(git status --porcelain -z --untracked-files=all | tr '\0' '\n' | cut -c 4- | _resolve_spec_files)"
  if [ -z "$FILES" ]; then
    echo rspec-work: no changes to test >&2
    return 1
  fi
  (
    [ -n "${ZSH_VERSION:-}" ] && setopt shwordsplit
    rspec $FILES "$@"
  )
}
alias rspec-work-doc='rspec-work -f doc'

function rubocop-branch {
  FILES="$(git diff $(git merge-base origin/HEAD HEAD).. --name-only)"
  FILES="$((echo "$FILES" | xargs find 2> /dev/null; echo "$FILES" | _resolve_spec_files) | sort -u)"
  RB_FILES="$(echo "$FILES" | grep '\.rb$')"
  if [ -z "$RB_FILES" ]; then
    echo rubocop-branch: no changes to test >&2
    return 1
  fi
  (
    [ -n "${ZSH_VERSION:-}" ] && setopt shwordsplit
    bundle exec rubocop $RB_FILES "$@"
  )
}

function __database_yml {
  if [[ -f config/database.yml ]]; then
    ruby -ryaml -rerb -e "puts YAML::load(ERB.new(IO.read('config/database.yml')).result)['${RAILS_ENV:-development}']['$1']"
  fi
}

function psql
{
  if [[ "$(__database_yml adapter)" == 'postgresql' ]]; then
    PGDATABASE="$(__database_yml database)" command psql "$@"
    return $?
  fi
  command psql "$@"
}

function mysql
{
  if [[ $# == 0 && "$(__database_yml adapter)" =~ 'mysql' ]]; then
    mysql -uroot "$(__database_yml database)"
    return $?
  fi
  command mysql "$@"
}
