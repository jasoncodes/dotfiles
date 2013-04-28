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
