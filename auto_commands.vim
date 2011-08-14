" Detect indent mode automatically (tab vs spaces)
autocmd BufReadPost * :DetectIndent

" Ruby files
autocmd FileType ruby,rails,haml,eruby,yaml,ru,cucumber set ai sw=2 sts=2 et
if has("gui_running")
  autocmd FileType ruby,rails,haml,eruby,yaml,ru,cucumber :SyntasticEnable
endif

" Markdown files
autocmd BufRead,BufNewFile {*.md,*.mkd,*.markdown} setlocal ft=markdown wrap

" Makefile
autocmd FileType make set noexpandtab

" NERDTree
" use shift-return to keep focus when opening a file
autocmd FileType nerdtree map <buffer> <S-CR> go

" Generate .git/tags (ctags) automatically on save
autocmd BufWritePost * call UpdateTags()
