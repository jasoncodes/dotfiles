install-ruby() {
  local VERSION="$1"
  if [ -z "$VERSION" ]; then
    echo "install-ruby: Specify the version of Ruby you want to install."
    echo
    echo "Available rubies:"
    ruby-build --definitions
    return 1
  fi
  brew update
  brew install rbenv ruby-build rbenv-vars readline openssl ctags
  if [ -n "${ZSH_VERSION:-}" ]; then
    echo 'eval "$(rbenv init - --no-rehash)"' >> ~/.zshrc
  else
    echo 'eval "$(rbenv init - --no-rehash)"' >> ~/.bash_profile
  fi
  eval "$(rbenv init - --no-rehash)" # load rbenv in the current shell
  export CONFIGURE_OPTS="--disable-install-doc --with-readline-dir=$(brew --prefix readline) --with-openssl-dir=$(brew --prefix openssl)"
  rbenv install $VERSION
  export RBENV_VERSION="$VERSION"
  gem install --no-ri --no-rdoc bundler rbenv-rehash git-up hitch gem-browse gem-ctags cheat awesome_print pry
  gem ctags
  echo "To make $VERSION your default Ruby, run the following:"
  echo
  echo "    rbenv global $VERSION"
}
