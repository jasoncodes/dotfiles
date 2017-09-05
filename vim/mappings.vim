" Yank from the cursor to the end of the line, to be consistent with C and D
nnoremap Y y$

" select last put
" src: http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Use `'` to repeat last `;` in reverse (default is `,`)
nnoremap ' ,

map <silent><Leader>r :checktime<CR>:silent! wall<CR>:up<CR>:redraw!<CR>:call gitgutter#all()<CR>

" select all
map <Leader>a ggVG

" Buffer navigation
map <Leader>, <C-^>
map <silent><Leader>q :Bclose<CR>
map <silent><Leader>Q :%bd<CR>

" replace bufkill's default mappings with something less conflicty
nmap \bb <Plug>BufKillBack
nmap \bf <Plug>BufKillForward
nmap \bun <Plug>BufKillBun
nmap \!bun <Plug>BufKillBangBun
nmap \bd <Plug>BufKillBd
nmap \!bd <Plug>BufKillBangBd
nmap \bw <Plug>BufKillBw
nmap \!bw <Plug>BufKillBangBw
nmap \bundo <Plug>BufKillUndo
nmap \ba <Plug>BufKillAlt

" Disable scrolling with the mouse
map <ScrollWheelUp> <Nop>
map <ScrollWheelDown> <Nop>
map <ScrollWheelLeft> <Nop>
map <ScrollWheelRight> <Nop>

" Convert between spaces and tabs
map <Leader>I :set list<CR>:FixWhitespace<CR>:ToggleTabs<CR>

" Bookmarking
map <C-Space> :ToggleBookmark<CR>
map <C-Up>    :PreviousBookmark<CR>
map <C-Down>  :NextBookmark<CR>

" Jump to start and end of line using the home row keys
map H ^
map L $

" I never intentionally lookup keywords (with `man`)
nmap K <Esc>

" gi moves to last insert mode
" gI moves to last modification
nnoremap gI `.

" Movement & wrapped long lines
" This solves the problem that pressing down jumps your cursor 'over' the current line to the next line
nnoremap j gj
nnoremap k gk

" quick mapping to execute the macro in q
map Q @q

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Save and restore window and cursor position
" This prevents the default <Leader>swp from conflicting with <Leader>sw
map \swp <Plug>SaveWinPosn
map \rwp <Plug>RestoreWinPosn
