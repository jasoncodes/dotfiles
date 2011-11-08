function! ToggleColors()
  if &background == 'dark'
    colorscheme bclear_jason
  else
    colorscheme jellybeans_jason
  end
endfunction
map <Leader>C :call ToggleColors()<CR>

set guioptions-=T " Hide the tool bar

" MacVim
if has("gui_macvim")
  source $HOME/.vim/gui_macvim.vim
endif

" VimEnter
if isdirectory(argv(0))
  au VimEnter * :NERDTreeToggle
  au VimEnter * :wincmd p
endif

" Cursor
set guicursor=a:blinkon0 " turn off cursor blink

" Color columns
hi ColorColumn guibg=#F0F0F0
