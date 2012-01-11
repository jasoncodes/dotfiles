set guifont=Monaco:h13

" Disable scrollbars
set guioptions-=rL

" Disable MacVim keybindings
macmenu &Edit.Find.Find\.\.\. key=<nop>
nmap <D-f> <Esc>
macmenu &File.New\ Tab key=<nop>
nmap <D-t> <Esc>
macmenu Window.Toggle\ Full\ Screen\ Mode key=<nop>

" Cmd+W to close current buffer and close the window if no buffers are left
macmenu &File.Close key=<nop>
nmap <D-w> :CommandW<CR>
imap <D-w> <Esc>:CommandW<CR>

" Disable Cmd+S to encourage `:w`
macmenu &File.Save key=<nop>
map <D-s> <Esc>
imap <D-s> <Esc><Esc>i
