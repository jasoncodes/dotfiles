if isdirectory(argv(0))
  au VimEnter * execute 'cd '.argv(0)
endif
