if !isdirectory(expand("~/.vim/.backup/"))
  silent !mkdir -p ~/.vim/.backup/
endif
set backupdir=$HOME/.vim/.backup
set directory=$HOME/.vim/.backup
set backupskip=/tmp/*,/private/tmp/*
