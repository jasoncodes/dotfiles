# I love colour
if ls --version 2> /dev/null | grep -q 'GNU coreutils'
then
  alias ls="ls --color=auto --classify --block-size=\'1"
else
  alias ls='ls -GFh'
fi
