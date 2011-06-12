" Remap leader to ',' which is much easier than '\'
let mapleader = ","

" Yank from the cursor to the end of the line, to be consistent with C and D
nnoremap Y y$

" Preserve cursor position when exiting insert mode
imap <Esc> <Esc><Right>

" NERDTree
map <Leader>n :NERDTreeToggle<CR>

" Trim & save
map <Leader>sd :FixWhitespace<CR>:w<CR>

" Buffer navigation
map <Leader>, <C-^>
map <Leader>t :CommandT
function CommandTWithFlush()
  CommandTFlush
  CommandT
endfunction
map <Leader>T :call CommandTWithFlush()

" Cycle between windows with Tab and Shift-Tab
map <Tab> :wincmd w<CR>
map <S-Tab> :wincmd W<CR>

" Clear search
map <silent><Leader>/ :let @/ = ""<CR>

" Toggle invisibles
noremap <Leader>i :set list!<CR>

" Page down with space
map <Space> <PageDown>

" Bookmarking
map <C-Space> :ToggleBookmark<CR>
map <C-Up>    :PreviousBookmark<CR>
map <C-Down>  :NextBookmark<CR>

" Colorscheme scroll
map <C-Left>  :PREVCOLOR<CR>
map <C-Right> :NEXTCOLOR<CR>

" Movement & wrapped long lines
" This solves the problem that pressing down jumps your cursor 'over' the current line to the next line
nnoremap j gj
nnoremap k gk

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

" Align Maps (mapping overrides)
map <Leader>am <Plug>AM_w=

" Rooter (mapping overrides)
map <Leader>ro <Plug>RooterChangeToRootDirectory

" TComment
let g:tcommentMapLeaderOp1 = '<Leader>c'
