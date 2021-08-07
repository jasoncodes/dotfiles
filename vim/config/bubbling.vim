Bundle 'matze/vim-move'
Bundle 'AndrewRadev/sideways.vim'

let g:move_map_keys = 0

exec "set <A-h>=\eh"
exec "set <A-j>=\ej"
exec "set <A-k>=\ek"
exec "set <A-l>=\el"

" Use option-J/K to bubble lines up and down
nmap <A-k> <Plug>MoveLineUp
nmap <A-j> <Plug>MoveLineDown
vmap <A-k> <Plug>MoveBlockUp
vmap <A-j> <Plug>MoveBlockDown
nmap <silent> ˚ <Plug>MoveLineUp
nmap <silent> ∆ <Plug>MoveLineDown
vmap <silent> ˚ <Plug>MoveBlockUp
vmap <silent> ∆ <Plug>MoveBlockDown

" Use option-H/L to bubble items (function arguments, etc) left and right
nmap <silent> <A-h> :SidewaysLeft<CR>
nmap <silent> <A-l> :SidewaysRight<CR>
nmap ˙ :SidewaysLeft<CR>
nmap ¬ :SidewaysRight<CR>
