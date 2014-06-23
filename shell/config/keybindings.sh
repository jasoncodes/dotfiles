# ^W deletes path segments
stty werase undef
bind '\C-w:unix-filename-rubout'

# allow ctrl-s to work
stty -ixon
