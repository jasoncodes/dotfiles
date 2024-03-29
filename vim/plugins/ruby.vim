Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-rake'
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'tpope/vim-haml'
Bundle 'kchmck/vim-coffee-script'
Bundle 'rking/vim-ruby-refactoring'
Bundle 'joker1007/vim-ruby-heredoc-syntax'

autocmd FileType ruby,rails,haml,hamlc,eruby,yaml,ru,cucumber set ai sw=2 sts=2 et
autocmd BufRead,BufNewFile Podfile,*.podspec set ft=ruby
autocmd BufRead,BufNewFile *.hamlc set ft=haml

let g:ruby_indent_assignment_style = 'variable'

let g:ruby_refactoring_map_keys = 0

let g:rails_projections = {
  \'app/lib/*.rb':{'test':'spec/lib/{}_spec.rb'},
  \'app/models/*.rb':{'related':['app/models/{}.sql','app/models/{}.sql.erb']},
  \'app/models/*.sql':{'related':'app/models/{}.rb'},
  \'app/models/*.sql.erb':{'related':'app/models/{}.rb'},
  \'app/sql/*.rb':{'related':['app/sql/{}.sql','app/sql/{}.sql.erb']},
  \'app/sql/*.sql':{'related':'app/sql/{}.rb'},
  \'app/sql/*.sql.erb':{'related':'app/sql/{}.rb'},
  \'config/initializers/*.rb':{'test':'spec/initializers/{}_spec.rb'},
  \'spec/initializers/*_spec.rb':{'alternate':'config/initializers/{}.rb'}
\}
