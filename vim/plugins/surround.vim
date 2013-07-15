Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'

let g:surround_no_mappings = 1

" change surrounding quotes: <Leader>sc"'
nmap <Leader>sc <Plug>Csurround
" delete surrounding quotes: <Leader>sd"
nmap <Leader>sd <Plug>Dsurround
" add surrounding quotes: <Leader>saiw"
nmap <Leader>sa <Plug>Ysurround
" add surrounding quotes to selection: <Leader>sa"
xmap <Leader>sa <Plug>VSurround
