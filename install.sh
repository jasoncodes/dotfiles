#!/bin/bash -e
cd
[ -d .dotfiles ] || git clone git://github.com/jasoncodes/dotfiles.git .dotfiles
( cd .dotfiles && git pull --stat )
find .dotfiles -maxdepth 1 -type f -not -name 'install.sh' -not -name 'README*' | while read SRC
do
	DST="`echo "$SRC" | sed -e 's#.*/#.#' -e 's#\.profile$#.bash_profile#'`"
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
done
