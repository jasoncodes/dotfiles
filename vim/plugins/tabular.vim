Bundle 'godlygeek/tabular'

augroup tabular
  autocmd VimEnter * AddTabularPipeline! table /^|/
    \ tabular#TabularizeStrings(a:lines, '\v\|+', 'l1')
    \ | map(a:lines, "substitute(v:val, '|  *', '| ', 'g')")
augroup end

" Align selected table with <Bar>
nmap <silent><Bar> :Tabularize table<CR>
