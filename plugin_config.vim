" Rails
let g:rails_menu = 0

" Syntastic
let g:syntastic_enable_signs = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_disabled_filetypes = ['cucumber']

" Ctrl-P
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_working_path_mode = 0 " Don't manage
let g:ctrlp_dotfiles = 0 " Ignore all dot/hidden files
let g:ctrlp_custom_ignore = {
 \ 'dir': '\.git$\|\.hg$\|\.svn$\|backups$\|logs$\|tmp$',
 \ 'file': '',
 \ 'link': '',
 \ }
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 10

" Kill buffers in Ctrl-P with Ctrl-@
" https://github.com/kien/ctrlp.vim/issues/280
let g:ctrlp_buffer_func = { 'enter': 'CtrlPEnter' }
func! CtrlPEnter()
  nnoremap <buffer> <silent> <C-@> :call <sid>CtrlPDeleteBuffer()<cr>
endfunc
func! s:CtrlPDeleteBuffer()
  exec "bd" fnamemodify(getline('.')[2:], ':p')
  exec "norm \<F5>"
endfunc

" Detect Indent
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 2

" Indent Guides
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1

" NERDCommenter
let g:NERDSpaceDelims = 1

" Quickfixsigns
let g:quickfixsigns_classes = ['vcsdiff']
