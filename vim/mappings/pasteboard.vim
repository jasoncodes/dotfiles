" Yank and put system pasteboard with <Leader>y/p.
noremap <Leader>y "*y
nnoremap <Leader>yy "*yy
noremap <Leader>p "*p
noremap <Leader>P "*P

" Copy relative path to the system pasteboard
nnoremap <silent><Leader>cf :let @*=expand('%')<CR>

" Copy relative path and line number to the system pasteboard
nnoremap <silent><Leader>cl :let @*=expand('%').':'.line('.')<CR>
