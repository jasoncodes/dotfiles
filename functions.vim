function! CommandTWithFlush()
  CommandTFlush
  CommandT
endfunction

command! -range=% -nargs=0 TabToSpace silent! execute "<line1>,<line2>s/^\\t\\+/\\=substitute(submatch(0), '\\t', repeat(' ', ".&ts."), 'g')"
command! -range=% -nargs=0 SpaceToTab silent! execute "<line1>,<line2>s/^\\( \\{".&ts."\\}\\)\\+/\\=substitute(submatch(0), ' \\{".&ts."\\}', '\\t', 'g')"

function! ToggleTabs()
  let l:save_cursor = getpos(".")
  if &expandtab
    SpaceToTab
  else
    TabToSpace
  endif
  call setpos('.', l:save_cursor)
  DetectIndent
endfunction
:command! -range=% -nargs=0 ToggleTabs call ToggleTabs()

" http://vim.wikia.com/wiki/Execute_commands_without_changing_the_search_register
" Executes a command (across a given range) and restores the search register when done.
function! SafeSearchCommand(line1, line2, theCommand)
  let search = @/
  execute a:line1 . "," . a:line2 . a:theCommand
  let @/ = search
endfunction
command! -range -nargs=+ SS call SafeSearchCommand(<line1>, <line2>, <q-args>)
" A nicer version of :s that doesn't clobber the search register
command! -range -nargs=* S call SafeSearchCommand(<line1>, <line2>, 's' . <q-args>)

function! UpdateTags()
  if exists('b:git_dir') && executable('ctags')
    call system('cd "'.b:git_dir.'/.." && nice ctags --tag-relative -R -f .git/tags --exclude=.git --langmap="ruby:+.rake.builder.rjs" . &')
  endif
endfunction

" Closes the quickfix window if it's open, overwise the focused window.
function! CloseWindow()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  close
endfunction
