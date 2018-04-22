" brew tap universal-ctags/universal-ctags
" brew install --HEAD universal-ctags
" gem install CoffeeTags

Bundle 'ludovicchabant/vim-gutentags'

let g:gutentags_cache_dir = '/tmp'
let g:gutentags_generate_on_empty_buffer = 1

if executable('ag')
  let g:gutentags_file_list_command = 'ag -l --nocolor -g ""'
end
if executable('rg')
  let g:gutentags_file_list_command = 'rg --files'
end
