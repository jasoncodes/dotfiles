Bundle 'ciaranm/detectindent'

let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 2
"
" Detect indent mode automatically (tab vs spaces)
autocmd BufReadPost * :DetectIndent
