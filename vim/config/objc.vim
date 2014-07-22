function! s:Alternate()
  if expand("%:e") == "m"
    find %:t:r.h
  else
    find %:t:r.m
  endif
endfunction

autocmd Filetype objc,objcpp command! -buffer -nargs=0 A call s:Alternate()
