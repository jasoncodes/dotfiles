#!/bin/bash
source "$HOME/.rvm/scripts/rvm"
rvm rbx
if ! echo "$RUBY_VERSION" | grep -q ^rbx
then
	echo "rbx not installed." >&2
	exit 1
fi
exec ruby "$@"
