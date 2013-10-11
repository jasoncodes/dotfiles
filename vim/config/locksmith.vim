function! s:Locksmith(bang, name)
  let dir = expand('~/.vim/locksmith-cache')
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif

  let file = dir . '/' . a:name . '.vim'
  if !filereadable(file) || a:bang
    call system('vim-locksmith '.shellescape(a:name).' > '.shellescape(file))
  endif

  execute 'source '.file
  echo 'Cut new key mappings for '.a:name
endfunction

command! -nargs=1 -bang Locksmith call s:Locksmith('!' == '<bang>', <q-args>)
