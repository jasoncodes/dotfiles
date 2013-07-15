Bundle 'bronson/vim-trailing-whitespace'

" trim & save
map <Leader>sd :FixWhitespace<CR>:up<CR>
map <Leader>sq :FixWhitespace<CR>:up<CR>:CommandW<CR>

" normalize whitespace
nmap <silent><Leader>ss :S/\(\S\)\s\+/\1 /ge<CR>:S/\s*$//e<CR>
vmap <silent><Leader>ss :S/\(\S\)\s\+/\1 /ge<CR>gv:S/\s*$//e<CR>
