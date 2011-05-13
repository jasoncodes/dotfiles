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

# if TextMate is available and we're in iTerm...
if [[ "$TERM_PROGRAM" =~ ^(iTerm|Terminal)\.app$ ]] && [[ -x "`which mate`" ]]
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

# add a poor facsimile for Linux's `free` if we're on Mac OS
if ! type free > /dev/null 2>&1 && [[ "$(uname -s)" == 'Darwin' ]]
then
  alias free="top -s 0 -l 1 -pid 0 -stats pid | grep '^PhysMem: ' | cut -d : -f 2- | tr ',' '\n'"
fi

# I love colour
if ls --version 2> /dev/null | grep -q 'GNU coreutils'
then
	export GREP_OPTIONS='--color=auto'
	alias ls="ls --color=auto --classify --block-size=\'1"
fi
alias dir='echo Use /bin/ls :\) >&2; false' # I used this to ween myself away from the 'dir' alias

# helper for git aliases
function git_current_tracking()
{
	local BRANCH="$(git describe --contains --all HEAD)"
	local REMOTE="$(git config branch.$BRANCH.remote)"
	local MERGE="$(git config branch.$BRANCH.merge)"
	if [ -n "$REMOTE" -a -n "$MERGE" ]
	then
		echo "$REMOTE/$(echo "$MERGE" | sed 's#^refs/heads/##')"
	else
		echo "\"$BRANCH\" is not a tracking branch." >&2
		return 1
	fi
}

# git log patch
function glp()
{
	# don't use the pager if in word-diff mode
	local pager="$(echo "$*" | grep -q -- '--word-diff' && echo --no-pager)"
	
	# use reverse mode if we have a range
	local reverse="$(echo "$*" | grep -q '\.\.' && echo --reverse)"
	
	# if we have no non-option args then default to listing unpushed commits in reverse moode
	if ! (for ARG in "$@"; do echo "$ARG" | grep -v '^-'; done) | grep -q . && git_current_tracking > /dev/null 2>&1
	then
		local default_range="$(git_current_tracking)..HEAD"
		local reverse='--reverse'
	else
		local default_range=''
	fi
	
	git $pager log --patch $reverse "$@" $default_range
}

# git log file
function glf()
{
	git log --format=%H --follow -- "$@" | xargs --no-run-if-empty git show --stat
}

# git log search
function gls()
{
	local phrase="$1"
	shift
	if [[ $# == 0 ]]
	then
		local default_range=HEAD
	fi
	glp --pickaxe-all -S"$phrase" "$@" $default_range
}

function rails_command
{
	local cmd=$1
	shift
	
	if [ -e script/rails ]; then
		script/rails "$cmd" "$@"
	else
		"script/$cmd" "$@"
	fi
}

# handy aliases
alias gitx='open -b nl.frim.GitX' # now you can "gitx ." just like you can "mate ."
alias qt='open -a "QuickTime Player"'
alias gl='git lg --all'
alias glw='glp --word-diff'
alias gco='git co'
alias gcp='git co -p'
alias gst='git status'
alias gd='git diff'
alias gdw='git --no-pager diff --word-diff'
alias gds='gd --cached'
alias gdsw='gdw --cached'
alias gar='git reset HEAD'
alias garp='git reset -p HEAD'
alias gap='git add -p'
alias gau='git ls-files --other --exclude-standard -z | xargs -0 git add -Nv'
alias gaur="git ls-files --exclude-standard --modified -z | xargs -0 git ls-files --stage -z | awk 'BEGIN { RS=\"\0\"; FS=\"\t\"; ORS=\"\0\" } { if (\$1 ~ / e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 /) { sub(/^[^\t]+\t/, \"\", \$0); print } }' | xargs -0t -n 1 git reset -q -- 2>&1 | sed -e \"s/^git reset -q -- /reset '/\" -e \"s/ *$/'/\""
alias gc='EDITOR="mate -wl1" git commit -v'
alias gca='gc --amend'
alias grt='git_current_tracking > /dev/null && git rebase -i $(git_current_tracking)'
alias gp='git push'
alias be='bundle exec'
alias ber='bundle exec rspec --drb --format=doc'
alias bec='bundle exec cucumber --drb'
alias cuke='CUCUMBER_FORMAT=pretty bec'
alias rc='rails_command console'
alias rs='rails_command server'
alias timestamp='gawk "{now=strftime(\"%F %T \"); print now \$0; fflush(); }"'

# awesome history tracking
export HISTSIZE=100000
export HISTFILESIZE=100000
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
[ -t 0 ] && stty erase `tput kbs`
# check for window resizing when ever the prompt is displayed
shopt -s checkwinsize
# display "user@hostname: dir" in the window title
if [[ "$TERM" =~ ^xterm ]]
then
	export PROMPT_COMMAND="$PROMPT_COMMAND; "'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
fi

# enable rvm if available
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
	source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]]; then
	source "/usr/local/rvm/scripts/rvm"
fi
[[ -n "$rvm_path" ]] && [[ -r "$rvm_path/scripts/completion" ]] && source "$rvm_path/scripts/completion"
export rvm_pretty_print_flag=1

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

# load Homebrew's shell completion
if which brew > /dev/null && [ -f "$(brew --prefix)/Library/Contributions/brew_bash_completion.sh" ]
then
	source "$(brew --prefix)/Library/Contributions/brew_bash_completion.sh"
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

function gup
{
	# subshell for `set -e` and `trap`
	(
		set -e # fail immediately if there's a problem
		
		# use `git-up` if installed
		if type git-up > /dev/null 2>&1
		then
			exec git-up
		fi
		
		# fetch upstream changes
		git fetch
		
		BRANCH=$(git describe --contains --all HEAD)
		if [ -z "$(git config branch.$BRANCH.remote)" -o -z "$(git config branch.$BRANCH.merge)" ]
		then
			echo "\"$BRANCH\" is not a tracking branch." >&2
			exit 1
		fi
		
		# create a temp file for capturing command output
		TEMPFILE="`mktemp -t gup.XXXXXX`"
		trap '{ rm -f "$TEMPFILE"; }' EXIT
		
		# if we're behind upstream, we need to update
		if git status | grep "# Your branch" > "$TEMPFILE"
		then
			
			# extract tracking branch from message
			UPSTREAM=$(cat "$TEMPFILE" | cut -d "'" -f 2)
			if [ -z "$UPSTREAM" ]
			then
				echo Could not detect upstream branch >&2
				exit 1
			fi
			
			# can we fast-forward?
			CAN_FF=1
			grep -q "can be fast-forwarded" "$TEMPFILE" || CAN_FF=0
			
			# stash any uncommitted changes
			git stash | tee "$TEMPFILE"
			[ "${PIPESTATUS[0]}" -eq 0 ] || exit 1
			
			# take note if anything was stashed
			HAVE_STASH=0
			grep -q "No local changes" "$TEMPFILE" || HAVE_STASH=1
			
			if [ "$CAN_FF" -ne 0 ]
			then
				# if nothing has changed locally, just fast foward.
				git merge --ff "$UPSTREAM"
			else
				# rebase our changes on top of upstream, but keep any merges
				git rebase -p "$UPSTREAM"
			fi
			
			# restore any stashed changes
			if [ "$HAVE_STASH" -ne 0 ]
			then
				git stash pop -q
			fi
			
		fi
		
	)
}

# http://github.com/therubymug/hitch
hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'

# filters for XML and JSON
alias xml='xmllint -format'
alias json='python -mjson.tool'

# be able to 'cd' into SMB URLs
# requires <http://github.com/jasoncodes/scripts/blob/master/smburl_to_path>
function cd_smburl()
{
	cd "`smburl_to_path "$1"`"
}

# begin awesome colour prompt..
export PS1=""

# add rvm version@gemset
if [[ -n "$rvm_path" ]]
then
	function __my_rvm_ps1()
	{
		[[ -z "$rvm_ruby_string" ]] && return
		if [[ -z "$rvm_gemset_name" && "$rvm_sticky_flag" -ne 1 ]]
		then
			[[ "$rvm_ruby_string" = "system" && ! -s "$rvm_path/config/alias" ]] && return
			grep -q -F "default=$rvm_ruby_string" "$rvm_path/config/alias" && return
		fi
		local full=$(
			"$rvm_path/bin/rvm-prompt" i v p g s |
			sed \
				-e 's/jruby-jruby-/jruby-/' -e 's/ruby-//' \
				-e 's/-head/H/' \
				-e 's/-2[0-9][0-9][0-9]\.[0-9][0-9]//' \
				-e 's/-@/@/' -e 's/-$//')
		[ -n "$full" ] && echo "$full "
	}
	export PS1="$PS1"'\[\033[01;30m\]$(__my_rvm_ps1)'
fi

# add user@host:path
export PS1="$PS1\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w"

function realpath()
{
	python -c 'import os,sys;print os.path.realpath(sys.argv[1])' "$@"
}

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
if which git > /dev/null
then
	GIT_COMPLETION_PATH="$(dirname $(realpath "$(which git)"))/../etc/bash_completion.d/git-completion.bash"
fi
if [ ! -f "$GIT_COMPLETION_PATH" ]
then
	GIT_COMPLETION_PATH=$(first_file_match -f \
		"/usr/local/git/contrib/completion/git-completion.bash" \
		"/opt/local/share/doc/git-core/contrib/completion/git-completion.bash" \
		"/etc/bash_completion.d/git" \
	)
fi
if [ -f "$GIT_COMPLETION_PATH" ]
then
	source "$GIT_COMPLETION_PATH"
	export GIT_PS1_SHOWDIRTYSTATE=1
	export GIT_PS1_SHOWSTASHSTATE=1
	export GIT_PS1_SHOWUNTRACKEDFILES=1
	export PS1="$PS1"'\[\033[01;30m\]$(__git_ps1 " (%s)")'
	complete -o bashdefault -o default -o nospace -F _git_log gl glp gls glw
	complete -o bashdefault -o default -o nospace -F _git_checkout gco gcp
	complete -o bashdefault -o default -o nospace -F _git_status gst
	complete -o bashdefault -o default -o nospace -F _git_diff gd gdw gds gdsw
	complete -o bashdefault -o default -o nospace -F _git_reset gar garp
	complete -o bashdefault -o default -o nospace -F _git_add gap
	complete -o bashdefault -o default -o nospace -F _git_commit gc gca
	complete -o bashdefault -o default -o nospace -F _git_push gp
fi

# finish off the prompt
export PS1="$PS1"'\[\033[00m\]\$ '
