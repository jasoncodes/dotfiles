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

" Cursor
set guicursor=a:blinkon0 " turn off cursor blink
set guicursor+=i:ver25-iCursor " colour cursor in insert mode
set guicursor+=c:block-cCursor " colour cursor in command mode

" Color columns
hi ColorColumn guibg=#F0F0F0
