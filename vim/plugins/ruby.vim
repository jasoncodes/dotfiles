Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-rake'
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'tpope/vim-haml'
Bundle 'kchmck/vim-coffee-script'
Bundle 'rking/vim-ruby-refactoring'

autocmd FileType ruby,rails,haml,hamlc,eruby,yaml,ru,cucumber set ai sw=2 sts=2 et
autocmd BufRead,BufNewFile Podfile,*.podspec set ft=ruby
autocmd BufRead,BufNewFile *.hamlc set ft=haml

let g:ruby_refactoring_map_keys = 0
