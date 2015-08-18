Bundle 'jasoncodes/vim-ruby'
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

let g:ruby_hanging_indent = 0

let g:ruby_refactoring_map_keys = 0

let g:rails_projections = {
  \'app/models/*.rb':{'related':'app/models/%s.sql*'},
  \'app/models/*.sql':{'related':'app/models/%s.rb'},
  \'app/models/*.sql.erb':{'related':'app/models/%s.rb'},
  \'app/sql/*.rb':{'related':'app/sql/%s.sql*'},
  \'app/sql/*.sql':{'related':'app/sql/%s.rb'},
  \'app/sql/*.sql.erb':{'related':'app/sql/%s.rb'}
\}
