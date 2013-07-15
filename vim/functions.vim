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
