Bundle 'bronson/vim-trailing-whitespace'

" http://vim.wikia.com/wiki/Execute_commands_without_changing_the_search_register
" Executes a command (across a given range) and restores the search register when done.
function! SafeSearchCommand(line1, line2, theCommand)
  let search = @/
  execute a:line1 . "," . a:line2 . a:theCommand
  let @/ = search
endfunction
command! -range -nargs=* SafeSubstitute call SafeSearchCommand(<line1>, <line2>, 's' . <q-args>)

" trim & save
map <Leader>sw :FixWhitespace<CR>:up<CR>
map <Leader>sq :FixWhitespace<CR>:up<CR>:CommandW<CR>

" normalize whitespace
nmap <silent><Leader>ss :SafeSubstitute/\(\S\)\s\+/\1 /ge<CR>:SafeSubstitute/\s*$//e<CR>
vmap <silent><Leader>ss :SafeSubstitute/\(\S\)\s\+/\1 /ge<CR>gv:SafeSubstitute/\s*$//e<CR>
