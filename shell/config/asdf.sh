# brew install asdf
# asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
# asdf install ruby "$(cat .ruby-version)"

if [ -e "$HOME/.asdf/asdf.sh" ]; then
  source "$HOME/.asdf/asdf.sh"
elif [ -e "/usr/local/opt/asdf/asdf.sh" ]; then
  source "/usr/local/opt/asdf/asdf.sh"
fi

export BUNDLE_JOBS=4
