" source: http://stackoverflow.com/a/26043227

function! ClearRegisters()
  redir => l:register_out
  silent register
  redir end
  let l:register_list = split(l:register_out, '\n')
  call remove(l:register_list, 0) " remove header (-- Registers --)
  call map(l:register_list, "substitute(v:val, '^.\\(.\\).*', '\\1', '')")
  call filter(l:register_list, 'v:val !~ "[%#=.:]"') " skip readonly registers
  for elem in l:register_list
    execute 'let @'.elem.'= ""'
  endfor
endfunction

command! ClearRegisters call ClearRegisters()
