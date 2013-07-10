alias cucumber='$([ -S .zeus.sock ] && echo zeus || echo bundle exec) cucumber -f fuubar'
alias cuke='$([ -S .zeus.sock ] && echo zeus || echo bundle exec) cucumber -f pretty'
alias zs='zeus start'
alias rc='$([ -S .zeus.sock ] && echo zeus console || echo bundle exec pry -r ./config/environment)'
alias rails='$([ -S .zeus.sock ] && echo zeus || echo rails_command)'
alias rs='rails server'
alias rg='rails generate'
alias rgm='rg migration'

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

  if [ -e script/rails ]; then
    script/rails "$cmd" "$@"
  elif [ -e "script/$cmd" ]; then
    "script/$cmd" "$@"
  else
    command rails "$cmd" "$@"
  fi
}

function rspec {
  if [ -S .zeus.sock ]; then
    local LAUNCHER='zeus'
  else
    local LAUNCHER='bundle exec'
  fi
  if egrep -q "^ {4}rails \(2\." Gemfile.lock; then
    local CMD='spec'
    local DEFAULT_FORMAT=nested
  else
    local CMD='rspec'
    local DEFAULT_FORMAT=doc
    if egrep -q fuubar Gemfile.lock; then
      local DEFAULT_FORMAT=Fuubar
    fi
  fi
  if [[ $# == 0 ]]; then
    set -- spec "$@"
  fi
  (
    [ -n "${ZSH_VERSION:-}" ] && setopt shwordsplit
    exec $LAUNCHER $CMD --color --format="${RSPEC_FORMAT:-$DEFAULT_FORMAT}" "$@"
  )
}
alias rspec-doc='RSPEC_FORMAT=doc rspec'

function rspec-branch {
  rspec $(
    git diff $(git merge-base origin/HEAD HEAD).. --name-only |
    sed 's#^app/\(.*\)\.rb$#spec/\1_spec.rb#' |
    grep '_spec\.rb$' |
    sort -u |
    xargs find 2> /dev/null
  )
}

function rspec-work {
  if [[ -z "$(git status --porcelain --untracked-files=all)" ]]; then
    echo rspec-work: no changes to test >&2
    return 1
  fi
  rspec $(
    git status --porcelain -z --untracked-files=all | tr '\0' '\n' | cut -c 4- |
    sed 's#^app/\(.*\)\.rb$#spec/\1_spec.rb#' |
    grep '_spec\.rb$' |
    sort -u |
    xargs find 2> /dev/null
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
export PSQL_EDITOR='vim +"set syntax=sql"'

function mysql
{
  if [[ $# == 0 && "$(__database_yml adapter)" =~ 'mysql' ]]; then
    mysql -uroot "$(__database_yml database)"
    return $?
  fi
  command mysql "$@"
}
