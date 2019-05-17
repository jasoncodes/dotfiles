function! Format(line1, line2)
  if getline(a:line1) =~ '^ *<'
    execute a:line1 . "," . a:line2 . "!xmllint -format -"
  else
    execute a:line1 . "," . a:line2 . "!ruby -rjson -e 'puts JSON.pretty_generate(JSON.parse(ARGF.read))'"
  endif
endfunction

command! -range=% Format call Format(<line1>, <line2>)
