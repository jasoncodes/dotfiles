Bundle 'airblade/vim-gitgutter'

set signcolumn=yes

let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 0

let g:gitgutter_sign_added = '⇒'
let g:gitgutter_sign_modified = '⇔'
let g:gitgutter_sign_removed = '⇐'
let g:gitgutter_sign_modified_removed = '⇎'

nmap ]d <Plug>(GitGutterNextHunk)
nmap [d <Plug>(GitGutterPrevHunk)

function! GitGutterModeMergeBase()
  let g:gitgutter_diff_base='$(git merge-base origin/HEAD HEAD)'

  GitGutterAll
endfunction

function! GitGutterModeUnstaged()
  let g:gitgutter_diff_base=''

  GitGutterAll
endfunction

function! GitGutterModeToggle()
  if g:gitgutter_diff_base == ''
    let g:gitgutter_diff_base='$(git merge-base origin/HEAD HEAD)'
  else
    let g:gitgutter_diff_base=''
  endif

  GitGutterAll
endfunction

nmap <silent> [og :call GitGutterModeMergeBase()<CR>
nmap <silent> ]og :call GitGutterModeUnstaged()<CR>
nmap <silent> yog :call GitGutterModeToggle()<CR>

autocmd BufReadPost * GitGutter
autocmd BufWritePost * GitGutter
