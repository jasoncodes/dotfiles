" In command-line mode, C-a jumps to beginning (to match C-e).
cnoremap <C-a> <Home>

" In command-line mode, C-k deletes to end of line
cnoremap <C-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>
