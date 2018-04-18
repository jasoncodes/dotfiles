function! s:ProfileStart()
  profile start profile.log
  profile func *
  profile file *
endfunction
command! ProfileStart call s:ProfileStart()

function! s:ProfileEnd()
  profile pause
  noautocmd qall
endfunction
command! ProfileEnd call s:ProfileEnd()
