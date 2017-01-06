Bundle 'chrisbra/csv.vim'

autocmd BufRead,BufNewFile .csv set filetype=csv

let g:csv_highlight_column = 'y'
let g:csv_hiGroup = 'Underlined'

autocmd Filetype csv setlocal nocursorline
autocmd Filetype csv let b:csv_arrange_align = 'l*'

autocmd Filetype csv autocmd CursorMoved <buffer> CSVWhatColumn!
