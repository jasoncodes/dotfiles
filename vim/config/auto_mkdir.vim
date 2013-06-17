function s:AutoMkdir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

autocmd BufWritePre * :call s:AutoMkdir(expand('<afile>'), +expand('<abuf>'))
