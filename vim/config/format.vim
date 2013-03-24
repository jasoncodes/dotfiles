function! Format(line1, line2)
  if getline(a:line1) =~ '^ *<'
    execute a:line1 . "," . a:line2 . "!xmllint -format -"
  else
    execute a:line1 . "," . a:line2 . "!python -mjson.tool | perl -pe 's{^(\\s*)}{\" \" x (length($1)/2)}e' | sed 's/ *$//'"
  endif
endfunction

command! -range=% Format call Format(<line1>, <line2>)
