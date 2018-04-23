Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'jasoncodes/ctrlp-modified.vim'
Bundle 'ivalkeen/vim-ctrlp-tjump'
Bundle 'FelikZ/ctrlp-py-matcher'
Bundle 'd11wtq/ctrlp_bdelete.vim'

let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_working_path_mode = 0 " Don't manage
let g:ctrlp_dotfiles = 0 " Ignore all dot/hidden files
let g:ctrlp_custom_ignore = {
 \ 'dir': '\.git$\|\.hg$\|\.svn$\|backups$\|logs$\|tmp$\|_site$',
 \ 'file': '',
 \ 'link': '',
 \ }
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_match_window = 'bottom,order:ttb,min:10,max:10'
let g:ctrlp_switch_buffer = ''

let g:ctrlp_match_func = {'match' : 'pymatcher#PyMatch' }

let g:ctrlp_buffer_func = { 'enter': 'ctrlp_bdelete#mappings' }

augroup ctrlp-tjump
  autocmd VimEnter * runtime autoload/ctrlp/tjump.vim
  autocmd VimEnter * let g:ctrlp_tjump_only_silent = 1
  autocmd VimEnter * let g:ctrlp_tjump_shortener = [getcwd() . '/', '']
  autocmd VimEnter * silent augroup! ctrlp-tjump
augroup end

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" ripgrep
if executable('rg')
 " Use rg over grep
 set grepprg=rg\ --vimgrep\ --no-heading
 set grepformat=%f:%l:%c:%m,%f:%l:%m

 " Use rg in CtrlP for listing files. Lightning fast and respects .gitignore
 let g:ctrlp_user_command = 'rg --files %s'

 " rg is fast enough that CtrlP doesn't need to cache
 let g:ctrlp_use_caching = 0
end

map <Leader>t :CtrlP<CR>
map <Leader>T :CtrlPClearAllCaches<CR>:CtrlP<CR>
map <Leader>l :CtrlPBuffer<CR>
map <Leader>m :CtrlPModified<CR>
map <Leader>M :CtrlPBranchModified<CR>
map <Leader>d :CtrlPCurFile<CR>
map <Leader>] :CtrlPTag<CR>
map <silent> <C-]> :CtrlPtjump<CR>
