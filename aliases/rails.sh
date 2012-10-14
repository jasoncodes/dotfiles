alias ber='$([ -S .zeus.sock ] && echo zeus || echo bundle exec) $(egrep -q "^ {4}rails \(2\." Gemfile.lock && echo spec --format=nested --colour || echo rspec --format=$(egrep -q fuubar Gemfile.lock && echo Fuubar || echo doc)) $([ -S .zeus.sock ] || echo --drb)'
alias bec='CUCUMBER_FORMAT=fuubar $([ -S .zeus.sock ] && echo zeus || echo bundle exec) cucumber $([ -S .zeus.sock ] || echo --drb)'
alias cuke='CUCUMBER_FORMAT=pretty $([ -S .zeus.sock ] && echo zeus || echo bundle exec) cucumber $([ -S .zeus.sock ] || echo --drb)'
alias besr='bundle exec spork rspec'
alias besc='bundle exec spork cucumber'
alias rc='$([ -S .zeus.sock ] && echo zeus console || echo pry -r ./config/environment)'
alias rs='$([ -S .zeus.sock ] && echo zeus server || rails_command server)'

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
