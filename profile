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

# if we're in Terminal.app we can add a few key bindings (Ctrl-T for new tab in pwd, Ctrl-N for new window)
if [ "$TERM_PROGRAM" == "Apple_Terminal" ]
then
	function term-bind()
	{
		term "$@" > /dev/null && echo -en "\033[1A"
	}
	bind -x '"\C-t":term-bind -t'
	bind -x '"\C-n":term-bind'
fi

# open man pages in Preview.app
if [ -d "/Applications/Preview.app" ]
then
	pman () {
		man -t "$@" |
		( which ps2pdf > /dev/null && ps2pdf - - || cat) |
		open -f -a /Applications/Preview.app
	}
fi

# add MacPorts to path if present
if [ -d '/opt/local' ]
then
	export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
	export PATH="$PATH:/opt/local/lib/postgresql84/bin"
	export MANPATH="/opt/local/share/man:$MANPATH"
fi

# our own bin dir at the highest priority, followed by /usr/local/bin
export PATH=~/bin:/usr/local/bin:/usr/local/sbin:"$PATH"

# I love colour
if ls --version 2> /dev/null | grep -q 'GNU coreutils'
then
	export GREP_OPTIONS='--color=auto'
	alias ls='ls --color=auto --classify'
fi
alias dir='echo Use /bin/ls :\) >&2; false' # I used this to ween myself away from the 'dir' alias

# handy aliases
alias gitx='open -b nl.frim.GitX' # now you can "gitx ." just like you can "mate ."
alias qt='open -a "QuickTime Player"'
alias gc='EDITOR="mate -wl1" git commit -v'

# awesome history tracking
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
export PROMPT_COMMAND='history -a'
shopt -s histappend
PROMPT_COMMAND='history -a; echo "$$ $USER $(history 1)" >> ~/.bash_eternal_history'

# notify of bg job completion immediately
set -o notify

# no mail notifications
shopt -u mailwarn
unset MAILCHECK

# I like backspace being ^H
[ ! -z "$TERM" ] && [ "$TERM" != "dumb" ] && stty erase `tput kbs`
# check for window resizing when ever the prompt is displayed
shopt -s checkwinsize
# display the 
if [ "$TERM" == "xterm" -o "$TERM" == "xterm-color" ]
then
	export PROMPT_COMMAND="$PROMPT_COMMAND; "'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
fi

# enable rvm if available
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
[[ -n "$rvm_path" ]] && [[ -r "$rvm_path/scripts/completion" ]] && source "$rvm_path/scripts/completion"

# set JAVA_HOME if on Mac OS
if [ -z "$JAVA_HOME" -a -d /System/Library/Frameworks/JavaVM.framework/Home ]
then
	export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
fi

# lesspipe lets us do cool things like view gzipped files
if [ -x "`which lesspipe`" ]
then
	eval "$(lesspipe)"
elif [ -x "`which lesspipe.sh`" ]
then
	eval "$(lesspipe.sh)"
fi


# this is more code than I had hoped in order to create aliases for gem commands I use a lot
# this caches the path to the gem's binary (and clears it if the gem path changes (i.e. rvm))
# the caching is most useful for snailgun but also others if they don't require rubygems themselves
function gem_bin_path
{
	
	local GEM_NAME="$1"
	local EXEC_NAME="$2"
	
	local GEMBIN_KEY="$GEM_PATH:`which ruby`" # expire if GEM_PATH or current Ruby changes
	
	if [ "`eval echo \\\$"GEMBIN_${GEM_NAME}_${EXEC_NAME}_KEY"`" == "$GEMBIN_KEY" ]
	then
		eval echo "\$GEMBIN_${GEM_NAME}_${EXEC_NAME}_VALUE"
		return
	fi
	
	local GEM_BIN_PATH=$(
		ruby <<-EOF
			require 'rubygems'
			gem "$GEM_NAME"
			if "$GEM_NAME".empty?
				puts Gem.dir
			else
				puts Gem.bin_path "$GEM_NAME", "$EXEC_NAME"
			end
		EOF
	)
	
	eval "GEMBIN_${GEM_NAME}_${EXEC_NAME}_KEY"='"$GEMBIN_KEY"'
	eval "GEMBIN_${GEM_NAME}_${EXEC_NAME}_VALUE"='"$GEM_BIN_PATH"'
	
	echo "$GEM_BIN_PATH"
	
}

function gem_exec
{
	local GEM_NAME="$1"
	local EXEC_NAME="$2"
	shift 2
	if gem_bin_path "$GEM_NAME" "$EXEC_NAME" | grep -q ^/ # ensure path is cached
	then
		"`gem_bin_path "$GEM_NAME" "$EXEC_NAME"`" "$@"
	else
		echo "gem_exec: $EXEC_NAME: command not found" >&2
	fi
}

function alias_gem_bin
{
	alias $2="gem_exec $1 $2"
}

alias_gem_bin snailgun fruby
alias_gem_bin snailgun fconsole
alias_gem_bin snailgun frake


# mategem makes it easy to open a gem in TextMate
# original src: <http://effectif.com/articles/opening-ruby-gems-in-textmate>
function mategem()
{
	local GEM="$1"
	if [ -z "$GEM" ]
	then
		echo "Usage: mategem <gem>" 1>&2
		false
	else
		gem_bin_path > /dev/null # init path
		mate "$(gem_bin_path)/gems/$GEM"
	fi
}
_mategem()
{
	local curw
	COMPREPLY=()
	curw=${COMP_WORDS[COMP_CWORD]}
	gem_bin_path > /dev/null # init path
	local gems="$(gem_bin_path)/gems"
	COMPREPLY=($(compgen -W '$(ls $gems)' -- $curw));
	return 0
}
complete -F _mategem -o dirnames mategem

# be able to 'cd' into SMB URLs
# requires <http://github.com/jasoncodes/scripts/blob/master/smburl_to_path>
function cd_smburl()
{
	cd "`smburl_to_path "$1"`"
}

# use rvm-mate if available
if [ -x "`which rvm-mate`" -a -x "`which mate`" ]
then
	alias mate=rvm-mate
fi

# begin awesome colour prompt..
export PS1=""

# add rvm version@gemset
if [[ -n "$rvm_path" ]]
then
	function __my_rvm_ps1()
	{
		[[ -z "$rvm_ruby_string" ]] && return
		if [[ -z "$rvm_gemset_name" ]]
		then
			[[ "$rvm_ruby_string" = "system" && ! -s "$rvm_path/config/alias" ]] && return
			grep -q -F "default=$rvm_ruby_string" "$rvm_path/config/alias" && return
		fi
		local full=$(
			"$rvm_path/bin/rvm-prompt" i v p g s |
			sed \
				-e 's/jruby-jruby-/jruby-/' -e 's/ruby-//' \
				-e 's/-head/H/' \
				-e 's/-@/@/' -e 's/-$//')
		[ -n "$full" ] && echo "$full "
	}
	export PS1="$PS1"'\[\033[01;30m\]$(__my_rvm_ps1)'
fi

# add user@host:path
export PS1="$PS1\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w"

function first_file_match()
{
	local OP="$1"
	shift
	while [ $# -gt 0 ]
	do
		if [ $OP "$1" ]
		then
			echo "$1"
			return 0
		fi
		shift
	done
	return 1
}

# add git status if available
GIT_COMPLETION_PATH=$(first_file_match -f \
	"/usr/local/git/contrib/completion/git-completion.bash" \
	"/opt/local/share/doc/git-core/contrib/completion/git-completion.bash" \
	"/etc/bash_completion.d/git" \
)
if [ -f "$GIT_COMPLETION_PATH" ]
then
	source "$GIT_COMPLETION_PATH"
	export GIT_PS1_SHOWDIRTYSTATE=1
	export GIT_PS1_SHOWSTASHSTATE=1
	export GIT_PS1_SHOWUNTRACKEDFILES=1
	export PS1="$PS1"'\[\033[01;30m\]$(__git_ps1 " (%s)")'
fi

# finish off the prompt
export PS1="$PS1"'\[\033[00m\]\$ '
