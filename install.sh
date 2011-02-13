#!/bin/bash -e
cd

[ -d .dotfiles ] || git clone git://github.com/jasoncodes/dotfiles.git .dotfiles
(
	set -e
	cd .dotfiles
	
	set +e
	[ -e profile ] && source profile
	set -e
	
	if type -t gup > /dev/null
	then
		gup
	else
		git pull --rebase --stat
	fi
)

function create_link()
{
	
	local SRC="$1"
	local DST="$2"
	
	if [ ! -e "$DST" ]
	then
		ln -sv "$SRC" "$DST"
	else
		if [ ! -L "$DST" ] || [ "`readlink "$DST"`" != "$SRC" ]
		then
			echo -n "dotfiles: $DST already exists" >&2
			if [ -L "$DST" ]
			then
				echo " (pointing to `readlink "$DST"`)"
			else
				echo " (not a symlink)"
			fi
		fi
	fi
	
}

find .dotfiles -maxdepth 1 -type f -not -name 'install.sh' -not -name 'README*' | while read SRC
do
	DST="`echo "$SRC" | sed -e 's#.*/#.#'`"
	if echo "$SRC" | grep -q /profile$
	then
		create_link "$SRC" .bash_profile
		create_link "$SRC" .bashrc
	else
		create_link "$SRC" "$DST"
	fi
done
