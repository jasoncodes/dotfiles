if match(map(copy(g:vundle#bundles), "v:val['name']"), 'vim-fugitive') < 0
  Bundle 'tpope/vim-fugitive'
end
