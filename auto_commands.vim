" Detect indent mode automatically (tab vs spaces)
autocmd BufReadPost * :DetectIndent

" Ruby files
autocmd FileType ruby,rails,haml,eruby,yaml,ru,cucumber set ai sw=2 sts=2 et
if has("gui_running")
  autocmd FileType ruby,rails,haml,eruby,yaml,ru,cucumber :SyntasticEnable
endif

" Set color column for features
autocmd BufWinEnter *.feature set cc+=11
autocmd BufWinLeave *.feature set cc-=11

" Markdown files
autocmd BufRead,BufNewFile {*.md,*.mkd,*.markdown} set ft=markdown

" Makefile
autocmd FileType make set noexpandtab
