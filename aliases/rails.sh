alias bec='CUCUMBER_FORMAT=fuubar $([ -S .zeus.sock ] && echo zeus || echo bundle exec) cucumber'
alias cuke='CUCUMBER_FORMAT=pretty $([ -S .zeus.sock ] && echo zeus || echo bundle exec) cucumber'
alias zs='zeus start'
alias rc='$([ -S .zeus.sock ] && echo zeus console || echo pry -r ./config/environment)'
alias rs='$([ -S .zeus.sock ] && echo zeus server || echo rails_command server)'
alias rg='$([ -S .zeus.sock ] && echo zeus generate || echo rails_command generate)'
alias rgm='rg migration'

zeus() {
  "$(/usr/bin/which zeus)" "$@"
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
  else
    "script/$cmd" "$@"
  fi
}

function ber {
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
  if [ $# == 0 ]; then
    set -- spec "$@"
  fi
  $LAUNCHER $CMD --color --format="${RSPEC_FORMAT:-$DEFAULT_FORMAT}" "$@"
}
alias berd='RSPEC_FORMAT=doc ber'

function __database_yml {
  if [[ -f config/database.yml ]]; then
    ruby -ryaml -rerb -e "puts YAML::load(ERB.new(IO.read('config/database.yml')).result)['${RAILS_ENV:-development}']['$1']"
  fi
}

function psql
{
  if [[ "$(__database_yml adapter)" == 'postgresql' ]]; then
    PGDATABASE="$(__database_yml database)" "$(/usr/bin/which psql)" "$@"
    return $?
  fi
  "$(/usr/bin/which psql)" "$@"
}
export PSQL_EDITOR='vim +"set syntax=sql"'

function mysql
{
  if [[ $# == 0 && "$(__database_yml adapter)" =~ 'mysql' ]]; then
    mysql -uroot "$(__database_yml database)"
    return $?
  fi
  "$(/usr/bin/which mysql)" "$@"
}
