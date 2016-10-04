# brew install chruby ruby-install
# ruby-install ruby 2.1.1
# echo 2.1.1 > ~/.ruby-version
# gem install bundler pry awesome_print git-up hitch gem-browse gem-ctags

CHRUBY_PATH=/usr/local/share/chruby
if [ -d "$CHRUBY_PATH" ]; then
  source "$CHRUBY_PATH/chruby.sh"
  source "$CHRUBY_PATH/auto.sh"
fi

export BUNDLE_JOBS=4
