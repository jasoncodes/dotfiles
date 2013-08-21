Bundle 'matze/vim-move'
Bundle 'AndrewRadev/sideways.vim'

let g:move_map_keys = 0

" Use option-J/K to bubble lines up and down
nmap <silent> ˚ <Plug>MoveLineUp
nmap <silent> ∆ <Plug>MoveLineDown
vmap <silent> ˚ <Plug>MoveBlockUp
vmap <silent> ∆ <Plug>MoveBlockDown

" Use option-H/L to bubble items (function arguments, etc) left and right
nmap ˙ :SidewaysLeft<CR>
nmap ¬ :SidewaysRight<CR>
