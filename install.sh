#!/bin/bash
if [ -d ~/.vim ]
then
  (cd ~/.vim && git-up)
else
  git clone git://github.com/jasoncodes/vimfiles.git ~/.vim
fi

if ! [ -d ~/.vim/bundle/vundle ]
then
  git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi

ln -sf .vim/vimrc ~/.vimrc
ln -sf .vim/gvimrc ~/.gvimrc

mkdir -p ~/.vim/.{backup,undo}

vim -N -u ~/.vimrc -es - <<-VIM
BundleInstall!
BundleClean
quit
VIM

(
  cd ~/.vim/bundle/Command-T/ruby/command-t
  if which ruby | grep -q '\.rvm'
  then
    rvm system exec ruby extconf.rb
  else
    ruby extconf.rb
  fi
  make
)
