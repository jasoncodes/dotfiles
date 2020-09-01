runtime colors/jellybeans.vim

let colors_name = "jellybeans_jason"

hi Normal ctermbg=16
hi NonText ctermbg=16
hi Normal guibg=#000000 ctermbg=16
hi NonText guibg=#000000 ctermbg=16
hi CursorLine ctermbg=233
hi CursorLineNr ctermbg=233 ctermfg=246 guifg=#a4a4a4 guibg=#151515
hi clear SignColumn
hi link SignColumn LineNr

hi Cursor  guibg=#afd700 guifg=black
hi iCursor guibg=#0087af
hi cCursor guibg=white

hi GitGutterAdd    guifg=#009900 guibg=#151515 ctermfg=2 ctermbg=233
hi GitGutterChange guifg=#bbbb00 guibg=#151515 ctermfg=3 ctermbg=233
hi GitGutterDelete guifg=#ff2222 guibg=#151515 ctermfg=1 ctermbg=233

hi IndentGuidesOdd  guibg=#0c0c0c ctermbg=232
hi IndentGuidesEven guibg=#181818 ctermbg=233

hi MatchParen cterm=none ctermbg=238 ctermfg=none

hi VertSplit ctermbg=235

hi Underlined NONE cterm=underline gui=underline
