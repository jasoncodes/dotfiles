" Remap leader to ',' which is much easier than '\'
let mapleader = ","

" Yank from the cursor to the end of the line, to be consistent with C and D
nnoremap Y y$

" NERDTree
map <Leader>n :NERDTreeToggle<CR>
map <Leader>N :NERDTree<CR>:wincmd p<CR>:NERDTreeFind<CR>

" Trim & save
map <Leader>sd :FixWhitespace<CR>:up<CR>
map <Leader>sw :FixWhitespace<CR>:up<CR>:CommandW<CR>
map ZZ :up<CR>:CommandW<CR>
map <silent><Leader>r :checktime<CR>:wall<CR>
map <Leader>Q :qall<CR>

" normalize whitespace
nmap <silent><Leader>ss :S/\(\S\)\s\+/\1 /ge<CR>:S/\s*$//e<CR>
vmap <silent><Leader>ss :S/\(\S\)\s\+/\1 /ge<CR>gv:S/\s*$//e<CR>

" select all
map <Leader>a ggVG

" Buffer navigation
map <Leader>, <C-^>
map <Leader>t :CommandT<CR>
map <Leader>T :call CommandTWithFlush()<CR>
map <Leader>w :CommandW<CR>
nmap <silent><Leader>q :call CloseWindow()<CR>
map <Leader>l :CommandTBuffer<CR>

" Copy relative path to the system pasteboard
nnoremap <silent><Leader>cf :let @*=expand('%')<CR>

" Copy relative path and line number to the system pasteboard
nnoremap <silent><Leader>cF :let @*=expand('%').':'.line('.')<CR>

" Disable scrolling while in both insert and visual modes
imap <ScrollWheelUp> <Nop>
imap <ScrollWheelDown> <Nop>
vmap <ScrollWheelUp> <Nop>
vmap <ScrollWheelDown> <Nop>

" Ack
map <Leader>f :Ack!<Space>
map <Leader>F :AckFromSearch!<CR>

" Cycle between windows with Tab and Shift-Tab
map <silent><Tab> :wincmd w<CR>
map <silent><S-Tab> :wincmd W<CR>

" Clear search
map <silent><Leader>/ :nohls<CR>

" Toggle word wrap
map <Leader>W :set wrap!<CR>

" Toggle spell checking
map <Leader>S :set spell!<CR>

" Toggle invisibles
noremap <Leader>i :set list!<CR>

" Convert between spaces and tabs
map <Leader>I :set list<CR>:FixWhitespace<CR>:ToggleTabs<CR>

" Page down with space
map <Space> <PageDown>

" Highlight word at cursor without changing position
nnoremap <leader>h *<C-O>
" Highlight word at cursor and then Ack it.
nnoremap <leader>H *<C-O>:AckFromSearch!<CR>

" Bookmarking
map <C-Space> :ToggleBookmark<CR>
map <C-Up>    :PreviousBookmark<CR>
map <C-Down>  :NextBookmark<CR>

" Jump to start and end of line using the home row keys
map H ^
map L $

" I never intentionally lookup keywords (with `man`)
nmap K <Esc>

" Movement & wrapped long lines
" This solves the problem that pressing down jumps your cursor 'over' the current line to the next line
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk

" Use option-J/K to bubble lines up and down
nmap <silent> ˚ <Plug>upAndDownUp
nmap <silent> ∆ <Plug>upAndDownDown
vmap <silent> ˚ <Plug>upAndDownVisualUp
vmap <silent> ∆ <Plug>upAndDownVisualDown
imap <silent> ˚ <Plug>upAndDownInsertUp
imap <silent> ∆ <Plug>upAndDownInsertDown

" Disable cursor keys
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <M-Down> <Nop>
inoremap <M-Left> <Nop>
inoremap <M-Right> <Nop>
noremap <Up> <Esc>
noremap <Down> <Esc>
noremap <Left> <Esc>
noremap <Right> <Esc>
noremap <S-Up> <Esc>
noremap <S-Down> <Esc>
vmap <Up> <Esc><Esc>gv
vmap <Down> <Esc><Esc>gv
vmap <Left> <Esc><Esc>gv
vmap <Right> <Esc><Esc>gv

nnoremap = v=

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Remove annoying F1 help
inoremap <F1> <Esc>
nnoremap <F1> <Esc>
vnoremap <F1> <Esc>

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without yanking
nmap <silent> <leader>d "_d
vmap <silent> <leader>d "_d

" Replace until end of line with yanked text
nmap <silent><Leader>p "_DP

" Align Maps (mapping overrides)
map <Leader>Am <Plug>AM_w=

" Rooter (mapping overrides)
map <Leader>R <Plug>RooterChangeToRootDirectory

" TComment
let g:tcommentMapLeaderOp1 = '<Leader>c'

" Align selected Cucumber table with <Bar>
vmap <silent><Bar> :Align <Bar><CR>gv:S/\s\+$//e<CR>gv:S/^\s//e<CR>gv<Esc>

" Save and restore window and cursor position
" This prevents the default <Leader>swp from conflicting with <Leader>sw
map \swp <Plug>SaveWinPosn
map \rwp <Plug>RestoreWinPosn

" Fold everything not relevant to the current RSpec example
nmap <silent> <Leader>rf mr:set foldmethod=syntax<CR>zMzv?\v^\s*(it\|example)<CR>zz:noh<CR>`r:delmarks r<CR>
