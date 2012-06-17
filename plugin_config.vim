" NERDTree
let g:NERDTreeHijackNetrw = 0
let g:loaded_netrw = 1 " Disable netrw
let g:loaded_netrwPlugin = 1 " Disable netrw
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeMinimalUI = 1 " Disable help message
let g:NERDTreeDirArrows = 1
let g:NERDTreeWinPos = 'right'

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

" Detect Indent
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 2

" Indent Guides
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1

" NERDCommenter
let g:NERDSpaceDelims = 1

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>e'

" Quickfixsigns
let g:quickfixsigns_classes = ['vcsdiff']
