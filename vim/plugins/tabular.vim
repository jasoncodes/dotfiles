Bundle 'godlygeek/tabular'

augroup tabular
  autocmd VimEnter * AddTabularPipeline! table /^|/
    \ tabular#TabularizeStrings(a:lines, '\v\|+', 'l1')
    \ | map(a:lines, "substitute(v:val, '|  *', '| ', 'g')")

  autocmd VimEnter * AddTabularPipeline! table_unalign /^|/
    \ map(a:lines, "substitute(v:val, '  *', ' ', 'g')")
augroup end

" Align selected table with <Bar>
nmap <silent><Bar> :Tabularize table<CR>

" Unalign selected table with g<Bar>
nmap <silent>g<Bar> :Tabularize table_unalign<CR>
