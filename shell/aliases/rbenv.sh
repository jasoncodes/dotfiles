ruby-install() {
  local VERSION="$1"
  if [ -z "$VERSION" ]; then
    echo "ruby-install: Specify the version of Ruby you want to install."
    echo
    echo "Available rubies:"
    ruby-build --definitions
    return 1
  fi
  brew update
  brew install rbenv ruby-build rbenv-vars readline openssl ctags
  brew upgrade rbenv ruby-build rbenv-vars readline openssl ctags
  if ! echo "$PATH" | grep -q .rbenv/shims; then
    echo You need to add the following to your shell config: >&2
    echo >&2
    echo '    eval "$(rbenv init - --no-rehash)"' >&2
    echo >&2
    echo 'If you use fresh <http://freshshell.com>, you could also just run the following:' >&2
    echo >&2
    echo '    fresh jasoncodes/dotfiles shell/config/rbenv.sh' >&2
    return 1
  fi
  if [[ -z "$SSL_CERT_FILE" ]]; then
    export SSL_CERT_FILE="/usr/local/etc/openssl/certs/cert.pem"
    echo You need to add the following to your shell config: >&2
    echo >&2
    echo "    export SSL_CERT_FILE=\"$SSL_CERT_FILE\"" >&2
    echo >&2
    echo 'If you use fresh <http://freshshell.com>, you could also just run the following:' >&2
    echo >&2
    echo '    fresh jasoncodes/dotfiles shell/config/rbenv.sh' >&2
    return 1
  fi
  if ! [[ -e "$SSL_CERT_FILE" ]]; then
    curl -o "$SSL_CERT_FILE" http://curl.haxx.se/ca/cacert.pem
  fi
  export CONFIGURE_OPTS="--disable-install-doc --with-readline-dir=$(brew --prefix readline) --with-openssl-dir=$(brew --prefix openssl)"
  rbenv install $VERSION
  export RBENV_VERSION="$VERSION"
  gem install --no-ri --no-rdoc bundler rbenv-rehash git-up hitch gem-browse gem-ctags cheat awesome_print pry
  gem ctags
  echo "To make $VERSION your default Ruby, run the following:"
  echo
  echo "    rbenv global $VERSION"
}
