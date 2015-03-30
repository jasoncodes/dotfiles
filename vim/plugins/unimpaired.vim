if match(map(copy(g:vundle#bundles), "v:val['name']"), 'vim-repeat') < 0
  Bundle 'tpope/vim-repeat'
end
Bundle 'tpope/vim-unimpaired'
