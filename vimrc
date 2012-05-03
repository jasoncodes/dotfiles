source $HOME/.vim/vundle.vim
source $HOME/.vim/global.vim
source $HOME/.vim/functions.vim
source $HOME/.vim/keybindings.vim
source $HOME/.vim/plugin_config.vim
source $HOME/.vim/auto_commands.vim

" `:cd` to the project root
au VimEnter * :Rooter

" Paste in non-GUI Vim with correct indentation when using Lion's Terminal or iTerm 1.0.0.20110908b+
" <http://stackoverflow.com/a/7053522/3736>
if &term =~ "xterm.*"
  let &t_ti = &t_ti . "\e[?2004h"
  let &t_te = "\e[?2004l" . &t_te
  function XTermPasteBegin(ret)
    set pastetoggle=<Esc>[201~
    set paste
    return a:ret
  endfunction
  map <expr> <Esc>[200~ XTermPasteBegin("i")
  imap <expr> <Esc>[200~ XTermPasteBegin("")
  cmap <Esc>[200~ <nop>
  cmap <Esc>[201~ <nop>
endif
