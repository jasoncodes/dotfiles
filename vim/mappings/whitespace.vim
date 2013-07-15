Bundle 'bronson/vim-trailing-whitespace'

" http://vim.wikia.com/wiki/Execute_commands_without_changing_the_search_register
" Executes a command (across a given range) and restores the search register when done.
function! SafeSearchCommand(line1, line2, theCommand)
  let search = @/
  execute a:line1 . "," . a:line2 . a:theCommand
  let @/ = search
endfunction
command! -range -nargs=+ SS call SafeSearchCommand(<line1>, <line2>, <q-args>)
" A nicer version of :s that doesn't clobber the search register
command! -range -nargs=* S call SafeSearchCommand(<line1>, <line2>, 's' . <q-args>)

" trim & save
map <Leader>sw :FixWhitespace<CR>:up<CR>
map <Leader>sq :FixWhitespace<CR>:up<CR>:CommandW<CR>

" normalize whitespace
nmap <silent><Leader>ss :S/\(\S\)\s\+/\1 /ge<CR>:S/\s*$//e<CR>
vmap <silent><Leader>ss :S/\(\S\)\s\+/\1 /ge<CR>gv:S/\s*$//e<CR>
