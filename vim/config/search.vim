Bundle 'mhinz/vim-grepper'

map <Leader>f :Grepper -query<Space>

let g:grepper = {}
let g:grepper.tools = ['rg', 'ag', 'ack', 'grep']
let g:grepper.rg = {}
let g:grepper.rg.grepprg = 'rg -H --no-heading --vimgrep --smart-case --sort-files'
let g:grepper.ack = {}
let g:grepper.ack.grepprg = 'ack -s -H --nocolor --nogroup --column'
let g:grepper.prompt = 0

function! ResizeGrepper()
  if winnr('$') > 1
    resize 10
  else
    resize 9001
  end
endfunction
autocmd User Grepper call ResizeGrepper()

function! EnableGrepperFileCompletion()
  redir => scriptnames
  silent! scriptnames
  redir END

  for script in split(l:scriptnames, "\n")
    if l:script =~ '/plugin/grepper.vim$'
      let l:script_num = str2nr(split(l:script, ":")[0])
      execute printf("command! -nargs=* -complete=file Grepper call <SNR>%d_parse_flags(<q-args>)", l:script_num)
    endif
  endfor
endfunction
autocmd VimEnter * call EnableGrepperFileCompletion()

" Find the next match as we type the search
set incsearch
" Highlight searches by default
set hlsearch

" Clear search
map <silent><Leader>/ :nohls<CR>

" Search for selected text, forwards or backwards.
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Highlight word at cursor without changing position
map <silent> <Leader>h :
  \:let view=winsaveview()<CR>
  \*
  \:call winrestview(view)<CR>
vmap <silent> <Leader>h :
  \:<C-U>let view=winsaveview()<CR>
  \gv*
  \:<C-U>call winrestview(view)<CR>

" Highlight word at cursor and then Ack it.
map <Leader>H <Leader>h:Grepper -cword -noprompt<CR>
