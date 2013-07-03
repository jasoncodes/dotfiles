Bundle 'tpope/vim-fugitive'

" dependencies:
"   brew install ctags
"   gem install CoffeeTags

function! UpdateTags()
  if exists('b:git_dir') && executable('ctags')
    call system('(cd "'.b:git_dir.'/.." && [ "$(pwd)" != /usr/local ] && rm -f .git/tags.new && PATH="/usr/local/bin:$PATH" nice ctags --tag-relative -R -f .git/tags.new --exclude=.git --langmap="ruby:+.rake.builder.rjs" . && (cd .git && find .. -name "*.coffee" | if which coffeetags &> /dev/null; then xargs coffeetags -f -; else true; fi) >> .git/tags.new && sort .git/tags.new > .git/tags && rm -f .git/tags.new) &')
  endif
endfunction

" Generate .git/tags (ctags) automatically on save
autocmd BufWritePost * call UpdateTags()

set tags+=.git/tags
