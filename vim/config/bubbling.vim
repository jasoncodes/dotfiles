Bundle 'upAndDown'
Bundle 'AndrewRadev/sideways.vim'

" Use option-J/K to bubble lines up and down
nmap <silent> ˚ <Plug>upAndDownUp
nmap <silent> ∆ <Plug>upAndDownDown
vmap <silent> ˚ <Plug>upAndDownVisualUp
vmap <silent> ∆ <Plug>upAndDownVisualDown
imap <silent> ˚ <Plug>upAndDownInsertUp
imap <silent> ∆ <Plug>upAndDownInsertDown

" Use option-H/L to bubble items (function arguments, etc) left and right
nmap ˙ :SidewaysLeft<CR>
nmap ¬ :SidewaysRight<CR>
