Bundle 'matze/vim-move'
Bundle 'AndrewRadev/sideways.vim'

let g:move_map_keys = 0

exec "set <A-h>=\eh"
exec "set <A-j>=\ej"
exec "set <A-k>=\ek"
exec "set <A-l>=\el"

exec "set <F31>=\e\e[A"
exec "set <F32>=\e\e[B"
exec "set <F33>=\e\e[D"
exec "set <F34>=\e\e[C"

" Use option-J/K to bubble lines up and down
nmap <A-k> <Plug>MoveLineUp
nmap <A-j> <Plug>MoveLineDown
vmap <A-k> <Plug>MoveBlockUp
vmap <A-j> <Plug>MoveBlockDown
nmap <F31> <Plug>MoveLineUp
nmap <F32> <Plug>MoveLineDown
vmap <F31> <Plug>MoveBlockUp
vmap <F32> <Plug>MoveBlockDown
nmap <silent> ˚ <Plug>MoveLineUp
nmap <silent> ∆ <Plug>MoveLineDown
vmap <silent> ˚ <Plug>MoveBlockUp
vmap <silent> ∆ <Plug>MoveBlockDown

" Use option-H/L to bubble items (function arguments, etc) left and right
nmap <silent> <A-h> :SidewaysLeft<CR>
nmap <silent> <A-l> :SidewaysRight<CR>
nmap <F33> :SidewaysLeft<CR>
nmap <F34> :SidewaysRight<CR>
nmap ˙ :SidewaysLeft<CR>
nmap ¬ :SidewaysRight<CR>
