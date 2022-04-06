# our own bin dir at the highest priority, followed by /usr/local/bin
export PATH=~/bin:~/.local/bin:/usr/local/bin:/usr/local/sbin:"$PATH"

# add Homebrew to the path if it's installed in /opt/homebrew
if ! which brew &> /dev/null && [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
