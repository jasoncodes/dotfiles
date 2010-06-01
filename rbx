#!/bin/bash -e
RBX_BIN="`find "${rvm_path:-$HOME/.rvm}/bin" -type f -name 'rbx-*' -maxdepth 1 | sort | tail -1`"
if [ -z "$RBX_BIN" ]
then
	echo "rbx not installed." >&2
	exit 1
fi
export RUBY_VERSION="`basename "$RBX_BIN"`"
export GEM_HOME="${rvm_path:-$HOME/.rvm}/gems/$RUBY_VERSION"
export GEM_PATH="${GEM_HOME}:${GEM_HOME}@global"
export MY_RUBY_HOME="${rvm_path:-$HOME/.rvm}/rubies/$RUBY_VERSION"
export PATH="$GEM_HOME/bin:$GEM_HOME@global/bin:$MY_RUBY_HOME/bin:$PATH"
export IRBRC="$MY_RUBY_HOME/.irbrc"
export BUNDLE_PATH="$GEM_HOME"
if [ ! -x "$MY_RUBY_HOME/bin/ruby" -o ! -d "$GEM_HOME" ]
then
	echo "rbx not found." >&2
	exit 1
fi
exec ruby "$@"
