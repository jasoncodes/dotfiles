" Detect indent mode automatically (tab vs spaces)
autocmd BufReadPost * :DetectIndent

" Save on FocusLost
autocmd FocusLost * nested :silent! wall

" Markdown files
autocmd BufRead,BufNewFile {*.md,*.mkd,*.markdown} setlocal ft=markdown wrap iskeyword+='

" Treat dasherised words as whole words in stylesheets
autocmd Filetype css,scss,sass setlocal iskeyword+=-

" Makefile
autocmd FileType make set noexpandtab

" Enable spell check by default for git commits
autocmd FileType gitcommit set spell

" Show the cursorline for the focused window
set cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Generate .git/tags (ctags) automatically on save
autocmd BufWritePost * call UpdateTags()
