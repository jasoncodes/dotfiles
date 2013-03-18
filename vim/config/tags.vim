function! UpdateTags()
  if exists('b:git_dir') && executable('ctags')
    call system('(cd "'.b:git_dir.'/.." && [ "$(pwd)" != /usr/local ] && nice ctags --tag-relative -R -f .git/tags.new --exclude=.git --langmap="ruby:+.rake.builder.rjs" . && mv .git/tags.new .git/tags) &')
  endif
endfunction

" Generate .git/tags (ctags) automatically on save
autocmd BufWritePost * call UpdateTags()

set tags+=.git/tags
