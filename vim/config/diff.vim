function! s:DiffWhitespaceToggle()
  if stridx(&diffopt, 'iwhite') > -1
    set diffopt-=iwhite
    echo 'set diffopt-=iwhite'
  else
    set diffopt+=iwhite
    echo 'set diffopt+=iwhite'
  endif
endfunction

function! s:DiffMappings()
  if &diff
    nmap <buffer> <silent> cob :call <sid>DiffWhitespaceToggle()<CR>
  end
endfunction

autocmd BufRead * call <sid>DiffMappings()
