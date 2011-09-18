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
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 0

" Command-T
let g:CommandTMaxFiles = 20000
let g:CommandTMinHeight = 10
let g:CommandTMaxHeight = 10
let g:CommandTMatchWindowAtTop = 0

" Indent Guides
let g:indent_guides_color_change_percent = 3
let g:indent_guides_enable_on_vim_startup = 1

" NERDCommenter
let g:NERDSpaceDelims = 1

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>e'

" Disable Surround's default bindings
" The default `ds` mapping screws with bufexplorer's `d`
let g:surround_no_mappings = 1
