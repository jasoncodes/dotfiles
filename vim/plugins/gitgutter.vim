Bundle 'airblade/vim-gitgutter'

let g:gitgutter_sign_column_always = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 0

let g:gitgutter_sign_added = '⇒'
let g:gitgutter_sign_modified = '⇔'
let g:gitgutter_sign_removed = '⇐'
let g:gitgutter_sign_modified_removed = '⇎'

nmap ]d <Plug>GitGutterNextHunk
nmap [d <Plug>GitGutterPrevHunk

function! ToggleGitGutterMode()
  if g:gitgutter_diff_args == ''
    let g:gitgutter_diff_args='$(git merge-base origin/HEAD HEAD)'
  else
    let g:gitgutter_diff_args=''
  endif

  GitGutterSignsDisable
  GitGutterSignsEnable
endfunction

nmap <silent> cog :call ToggleGitGutterMode()<CR>
