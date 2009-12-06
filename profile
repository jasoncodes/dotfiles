# locale stuff
export LANG=en_AU.UTF-8
export LC_CTYPE=en_US.UTF-8

# general shell settings
export PS1='\u@\h:\w\$ ' # basic prompt. get's overwritten later
export FIGNORE="CVS:.DS_Store:.svn:__Alfresco.url"
export EDITOR='nano'
export PAGER='less -SFX'
export MAKEFLAGS='-j 3'
complete -d cd mkdir rmdir

# set CVS to use :ext: via SSH (preferring ssh-master if available)
if [ -x "`which ssh-master`" ]
then
	export CVS_RSH=ssh-master
else
	export CVS_RSH=ssh
fi

# if TextMate is available and we're in Terminal.app...
if [ "$TERM_PROGRAM" == "Apple_Terminal" -a -x "`which mate`" ]
then
	export LESSEDIT='mate -l %lm %f' # press V in less to edit the file in TextMate
fi

# I love colour
export GREP_OPTIONS='--color=auto'
alias ls='ls --color=auto --classify'
alias dir='echo Use /bin/ls :\) >&2; false' # I used this to ween myself away from the 'dir' alias

# handy aliases
alias gitx='open -b nl.frim.GitX' # now you can "gitx ." just like you can "mate ."

# awesome history tracking
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
export PROMPT_COMMAND='history -a'
shopt -s histappend
PROMPT_COMMAND='history -a; echo "$$ $USER $(history 1)" >> ~/.bash_eternal_history'

# I like backspace being ^H
[ ! -z "$TERM" ] && [ "$TERM" != "dumb" ] && stty erase `tput kbs`
# check for window resizing when ever the prompt is displayed
shopt -s checkwinsize
# display the 
if [ "$TERM" == "xterm" -o "$TERM" == "xterm-color" ]
then
	export PROMPT_COMMAND="$PROMPT_COMMAND; "'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
fi

# begin awesome colour prompt..
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w'

# add git status if available
GIT_COMPLETION_PATH="/opt/local/share/doc/git-core/contrib/completion/git-completion.bash"
if [ -f "$GIT_COMPLETION_PATH" ]
then
	source "$GIT_COMPLETION_PATH"
	export GIT_PS1_SHOWDIRTYSTATE=1
	export PS1="$PS1"'\[\033[01;30m\]$(__git_ps1 " (%s)")'
fi

# finish off the prompt
export PS1="$PS1"'\[\033[00m\]\$ '

# add /usr/local (MacPorts) stuff to path
if [ -d '/usr/local' ]
then
	export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
	export PATH="$PATH:/opt/local/lib/postgresql84/bin"
	export MANPATH="/opt/local/share/man:$MANPATH"
fi

# our own bin dir at the highest priority, followed by /usr/local/bin
export PATH=~/bin:/usr/local/bin:"$PATH"

# be able to 'cd' into SMB URLs
# requires <http://github.com/jasonw/scripts/blob/master/smburl_to_path>
function cd_smburl()
{
	cd "`smburl_to_path "$1"`"
}
