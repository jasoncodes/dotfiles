filetype plugin indent on                  " Enable automatic filetype detection, filetype-specific plugins/indentation
syntax on                                  " Turn on syntax highlighting
set nocompatible                           " Don't need to keep compatibility with Vi
set hidden                                 " Allow hiding buffers with unsaved changes
set listchars=trail:.,tab:▸\ ,eol:¬        " Change the invisible characters
set fillchars+=vert:\                      " Hide pipes on vertical splits
set nolist                                 " Hide invisibles by default
set showcmd                                " Show incomplete cmds down the bottom
set showmode                               " Show current mode down the bottom
set history=1000                           " Remember more history for commands and search patterns
set ttyfast                                " More smooth screen redrawing
set noesckeys                              " Disable extended key support (cursor keys, function keys). Improves <Esc> time dramatically.
set ruler                                  " Show ruler
set number                                 " Show line numbers
set mouse=                                 " Disable the mouse
set linespace=2                            " Spacing between lines
set noswapfile                             " Disable creation of *.swp files
set title                                  " Show title in terminal vim
set modelines=1                            " Check the first line of files for a modeline (tab vs spaces, etc)
set autoread                               " Automatically reload externally modified files when clean
set autowriteall                           " Automatically write modified files
set spelllang=en_au                        " Set default spelling language to English (Australia)
set shortmess+=I                           " Disable splash screen
set noequalalways                          " Don't equalize when opening/closing windows
set nojs                                   " Don't use two spaces when joining sentences

" Indentation
set shiftwidth=2                           " Number of spaces to use in each autoindent step
set tabstop=2                              " Two tab spaces
set softtabstop=2                          " Number of spaces to skip or insert when <BS>ing or <Tab>ing
set expandtab                              " Spaces instead of tabs for better cross-editor compatibility
set autoindent                             " Keep the indent when creating a new line
set smarttab                               " Use shiftwidth and softtabstop to insert or delete (on <BS>) blanks
set cindent                                " Recommended seting for automatic C-style indentation
set autoindent                             " Automatic indentation in non-C files
set foldmethod=indent                      " Fold based on source indentation
set foldlevelstart=99                      " Expand all folds by default

" Wrap
set nowrap                                 " I don't always wrap lines...
set linebreak                              " ...but when I do, I wrap whole words.
set wildmenu                               " Make tab completion act more like bash
set wildmode=list:longest                  " Tab complete to longest common string, like bash
set nofileignorecase                       " case sensitive filename completion
set switchbuf=useopen                      " Don't re-open already opened buffers

" Moving around / editing
set nostartofline                          " Avoid moving cursor to BOL when jumping around
set scrolloff=3                            " Keep 3 context lines above and below the cursor
set backspace=2                            " Allow backspacing over autoindent, EOL, and BOL
set showmatch                              " Briefly jump to a paren once it's balanced
set matchtime=2                            " (for only .2 seconds).

" Searching
set ignorecase                             " Ignore case by default when searching
set smartcase                              " Switch to case sensitive mode if needle contains uppercase characters

" Use % to jump to matching begin/end of blocks as well as brackets/parens
runtime macros/matchit.vim

" Default colourscheme
if has("gui_running") || &t_Co == 88 || &t_Co == 256
  colorscheme jellybeans_jason
end
