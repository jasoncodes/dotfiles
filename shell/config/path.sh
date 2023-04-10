# our own bin dir at the highest priority, followed by /usr/local/bin
export PATH=~/bin:~/.local/bin:/usr/local/bin:/usr/local/sbin:"$PATH"

# add Homebrew to the path if it's installed in /opt/homebrew
if ! which brew &> /dev/null && [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# add libpq to the path for PostgreSQL client tools
homebrew_libpq_bin="${HOMEBREW_PREFIX:-/usr/local}/opt/libpq/bin"
if [ -d "$homebrew_libpq_bin" ]; then
  export PATH="$homebrew_libpq_bin:$PATH"
fi
unset homebrew_libpq_bin
