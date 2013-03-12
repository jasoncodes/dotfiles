#!/bin/bash -e
cd

if [ -d ~/.dotfiles ]; then
  if type -t git-up > /dev/null; then
    (cd ~/.dotfiles && git-up)
  else
    (cd ~/.dotfiles && git pull --rebase)
  fi
else
  git clone git://github.com/jasoncodes/dotfiles.git ~/.dotfiles
fi

bash -c "`curl -sL get.freshshell.com`"
