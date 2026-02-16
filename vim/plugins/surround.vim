"Change surrounds
if match(map(copy(g:vundle#bundles), "v:val['name']"), 'vim-repeat') < 0
  Bundle 'tpope/vim-repeat'
end
Bundle 'tpope/vim-surround'
let g:surround_113  = "#{\r}"   " v
let g:surround_35   = "#{\r}"   " #
let g:surround_40   = "(\r)"    " (
let g:surround_41   = "(\r)"    " )
let g:surround_123  = "{\r}"    " {
let g:surround_125  = "{\r}"    " }
let g:surround_91   = "[\r]"    " [
let g:surround_93   = "[\r]"    " ]
let g:surround_69   = "expect(\r).to"    " E
