Bundle 'chrisbra/csv.vim'

let g:csv_highlight_column = 'y'
let g:csv_hiGroup = 'Underlined'

autocmd Filetype csv setlocal nocursorline
autocmd Filetype csv let b:csv_arrange_align = 'l*'

function! CSVAutoWhatColumn()
  if &filetype == 'csv'
    CSVWhatColumn!
  endif
endfunction

autocmd Filetype csv autocmd CursorMoved <buffer> call CSVAutoWhatColumn()
