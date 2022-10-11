alias zs='zeus start'
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

ss() {
  if [ -x bin/spring ]; then
    bin/spring server "$@"
  else
    command ss "$@"
  fi
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
  elif [ "$cmd" == "new" ]; then
    command rails "$cmd" "$@"
  else
    echo "Not a Rails app?" >&2
    return 1
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
  if command -v _git_assert_origin_head &> /dev/null; then
    _git_assert_origin_head || return 1
  fi
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

function __ruby {
  if [ -x /usr/bin/ruby ]; then
    /usr/bin/ruby "$@"
  else
    ruby "$@"
  fi
}

function __database_yml {
  if [[ -f config/database.yml ]]; then
    __ruby -ryaml -rerb - <<RUBY "$@"
t = ERB.new(IO.read('config/database.yml'))
t.filename = 'config/database.yml'
c = YAML::load(t.result)
c = c.fetch(ENV.fetch('RAILS_ENV', 'development'))
c = c.fetch('primary') if c.key?('primary')
ARGV.each do |key|
  puts c.dig(key)
end
RUBY
  fi
}

function __pg_url_env {
  __ruby -ruri -rcgi -rshellwords - <<RUBY "$@"
  fail ArgumentError unless ARGV.size == 1
  uri = URI.parse(ARGV.first)
  fail ArgumentError, "invalid URL: #{uri}" unless uri.scheme == 'postgresql'

  %i[host port user password database].each do |key|
    value = case key
    when :database
      File.basename(CGI.unescape(uri.path))
    else
      uri.public_send(key)
    end

    if value
      puts "PG#{key.upcase}=#{Shellwords.escape value}"
    end
  end
RUBY
}

function psql
{
  (
    set -ueo pipefail

    if [ -z "${DATABASE_URL:-}" ]; then
      export DATABASE_URL="$(__database_yml url)"
    fi

    if [ -n "${DATABASE_URL:-}" ]; then
      pg_env="$(__pg_url_env "$DATABASE_URL")"
      eval "$(echo "$pg_env" | sed 's/^/export /')"
    elif [[ "$(__database_yml adapter)" == 'postgresql' ]]; then
      export PGDATABASE="$(__database_yml database)"
    fi

    exec psql "$@"
  )
}
