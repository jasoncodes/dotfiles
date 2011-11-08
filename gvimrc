set background=dark
colorscheme jellybeans_jason
let g:indent_guides_auto_colors = 1

function! ToggleColors()
  if &background == 'dark'
    colorscheme bclear
    set background=light
  else
    set background=dark
    colorscheme jellybeans_jason
  end
  IndentGuidesToggle
  IndentGuidesToggle
  hi Cursor guifg=black guibg=green
  hi iCursor guifg=black guibg=green
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
hi Cursor guifg=black guibg=green
hi iCursor guifg=black guibg=green
set guicursor=a:blinkon0 " turn off cursor blink

" Color columns
hi ColorColumn guibg=#F0F0F0
