source $HOME/.vim/vundle.vim
source $HOME/.vim/global.vim
source $HOME/.vim/functions.vim
source $HOME/.vim/keybindings.vim
source $HOME/.vim/plugin_config.vim
source $HOME/.vim/auto_commands.vim

" `:cd` to the project root
au VimEnter * :Rooter

" Use a bar cursor for insert mode under iTerm
if exists('$TMUX')
  let &t_SI = "\<Esc>[3 q"
  let &t_EI = "\<Esc>[0 q"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
