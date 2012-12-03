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

function create_link()
{

  local SRC="$1"
  local DST="$2"

  if [ ! -e "$DST" ]
  then
    ln -sv "$SRC" "$DST"
  else
    if [ ! -L "$DST" ] || [ "`readlink "$DST"`" != "$SRC" ]
    then
      echo -n "dotfiles: $DST already exists" >&2
      if [ -L "$DST" ]
      then
        echo " (pointing to `readlink "$DST"`)"
      else
        echo " (not a symlink)"
      fi
    fi
  fi

}

find .dotfiles -maxdepth 1 -type f -not -name 'install.sh' -not -name 'README*' | while read SRC
do
  DST="`echo "$SRC" | sed -e 's#.*/#.#'`"
  case "$SRC" in
    */profile)
      create_link "$SRC" .bash_profile
      create_link "$SRC" .bashrc
      ;;
    *)
      create_link "$SRC" "$DST"
      ;;
  esac
done

if [ -e ~/.fresh/build/shell.sh ]; then
  source ~/.fresh/build/shell.sh
  fresh
else
  bash -c "`curl -sL get.freshshell.com`"
fi
