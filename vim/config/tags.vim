" brew tap universal-ctags/universal-ctags
" brew install --HEAD universal-ctags
" gem install CoffeeTags

Bundle 'ludovicchabant/vim-gutentags'

let g:gutentags_cache_dir = '/tmp'
let g:gutentags_generate_on_empty_buffer = 1
