alias gl='glg $(git show-ref | cut -d " " -f 2 | grep -v stash$) HEAD'
alias glw='glp --word-diff'
alias gsw='git show --format=fuller'
alias gco='git checkout'
alias gcp='git checkout -p'
alias gs='git status --untracked-files=all'
alias gst='git stash --include-untracked --keep-index'
alias gstp='git stash pop'
alias gd='git diff -M40'
alias gdw='gd --word-diff=color --word-diff-regex="[A-z0-9_-]+"'
alias gbdw='gbd --word-diff=color --word-diff-regex="[A-z0-9_-]+"'
alias gds='gd --cached'
alias gdsw='gdw --cached'
alias gbd='_git_assert_origin_head && gd $(git merge-base origin/HEAD HEAD)..'
alias gbdd='_git_assert_origin_head && git diffall $(git merge-base origin/HEAD HEAD) HEAD'
alias gbdt='_git_assert_origin_head && git difftool $(git merge-base origin/HEAD HEAD)..'
alias gbl='_git_assert_origin_head && git-log --reverse $(git merge-base origin/HEAD HEAD)..'
alias gblp='_git_assert_origin_head && glp $(git merge-base origin/HEAD HEAD)..'
alias gblg='gblp --no-patch'
alias gar='git reset HEAD'
alias garp='git reset -p HEAD'
alias ga='git add'
alias gap='git add -p'
alias gld="git fsck --lost-found | grep '^dangling commit' | cut -d ' ' -f 3- | xargs git show -s --format='%ct %H' | sort -nr | cut -d ' ' -f 2 | xargs git show --stat"
alias gc='git commit -v'
alias gca='gc --amend'
alias gru='git rebase @{u}'
alias grc='git rebase --continue'
alias gp='git push'
alias gpt='git push -u origin $(git_current_branch)'
alias gws='git wip save WIP --untracked'
alias gwd='git update-ref -d refs/wip/$(git_current_branch)'
alias gdt='git difftool'
alias grl="git reflog --format='%C(auto)%h %<|(17)%gd %C(blue)%ci%C(reset) %gs'"
alias gtl='grep -v -F -f <(git ls-remote --tags origin | cut -d / -f 3) <(git tag)'
alias gcs='git commit --allow-empty --squash'

# helper for git aliases
function git_current_branch()
{
  git symbolic-ref --short -q HEAD
}

function git_current_tracking()
{
  local BRANCH="$(git_current_branch)"
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

function _git_assert_origin_head() {
  if ! git rev-parse origin/HEAD &> /dev/null; then
    if git rev-parse origin/develop &> /dev/null; then
      local TARGET=develop
    else
      local TARGET=master
    fi

    echo fatal: origin/HEAD is not set. >&2
    echo >&2
    echo "Maybe run \`git remote set-head origin $TARGET\`?" >&2
    return 1
  fi
}

_git_rebase_target() {
  if git rev-parse @{u} &> /dev/null; then
    echo "@{u}"
  else
    _git_assert_origin_head
    echo "origin/HEAD"
  fi
}

function git-log() {
  git log -M40 --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %C(green bold)- %an %C(black bold)%cd (%cr)%Creset' --abbrev-commit --date=short "$@"
}

# git log
function glg() {
  if [[ $# == 0 ]] && git rev-parse @{u} &> /dev/null; then
    git-log --graph @{u} HEAD
  else
    git-log --graph "$@"
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
    local default_range="@{upstream}..HEAD"
    local reverse='--reverse'
  else
    local default_range=''
  fi

  git $pager log --patch-with-stat -M40 $reverse "$@" $default_range
}

# git log file
function glf()
{
  git log -M40 --format=%H --follow -- "$@" | xargs --no-run-if-empty git show --stat
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

# git pull request
# checkout a GitHub pull request as a local branch
function gpr()
{
  local TEMP_FILE="$(mktemp "${TMPDIR:-/tmp}/gpr.XXXXXX")"
  echo '+refs/pull/*/head:refs/remotes/origin/pr/*' > "$TEMP_FILE"
  git config --get-all remote.origin.fetch | grep -v 'refs/remotes/origin/pr/\*$' >> "$TEMP_FILE"
  git config --unset-all remote.origin.fetch
  cat "$TEMP_FILE" | while read LINE
  do
    git config --add remote.origin.fetch "$LINE"
  done
  rm "$TEMP_FILE"

  git fetch
  if [[ -n "$1" ]]; then
    git checkout "pr/$1"
  fi
}

# git update
function gup
{
  if type git-up > /dev/null 2>&1
  then
    git-up "$@"
  else
    echo 'git-up not installed. Run `gem install git-up`.' 2> /dev/null
    return 1
  fi
}

# git add untracked
gau() {
  git ls-files --other --exclude-standard -z "$@" | xargs -0 git add -Nv
}

# git add untracked reset
gaur() {
  git ls-files --exclude-standard --modified -z "$@" | xargs -0 git ls-files --stage | while read MODE OBJECT STAGE NAME; do
    if [[ "$OBJECT" == e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 ]]; then
      echo "reset '$NAME'"
      if git rev-parse --quiet --verify HEAD > /dev/null; then
        git reset -q -- "$NAME" 2>&1
      else
        git rm --cached --quiet -- "$NAME"
      fi
    fi
  done
}

# git commit fixup
gcf() {
  if [[ $# -gt 0 ]]; then
    git commit --fixup "$@"
    return
  fi

  if [[ $(git diff --staged --name-only | wc -l) -lt 1 ]]; then
    echo Nothing staged to commit. >&2
    return 1
  fi

  COMMITS="$(
    git diff --staged --name-only -z |
      xargs -0 git log --pretty=format:'%H %s' $(git merge-base origin/HEAD HEAD).. -- |
      awk '{ if ($2 != "fixup!" && $2 != "squash!") { print $1} }'
  )"

  case $(echo "$COMMITS" | grep . | wc -l | tr -d -c 0-9) in
    0)
      echo No fixup candidates found. >&2
      return 1
      ;;
    1)
      git commit --fixup "$COMMITS"
      ;;
    *)
      echo Staged files:
      git diff --staged --name-only | sed 's/^/  /'

      echo
      echo Multiple fixup candidates:
      echo "$COMMITS" | xargs git show -s --oneline | sed 's/^/  /'

      echo
      echo Old hunks:
      git diff --staged --no-prefix | grep -e ^--- -e ^@@ | sed -e 's/ /	/' -e 's/^\(@@[^ ]*\) /\1	/' | while IFS='	' read MARKER VALUE _; do
        case "$MARKER" in
          ---)
            FILENAME="$VALUE"
            ;;
          @@)
            RANGE="$(echo "$VALUE" | sed s/-//)"
            if ! echo "$RANGE" | grep -q ,; then
              RANGE="$RANGE,1"
            fi
            RANGE="$(echo "$RANGE" | sed s/,/,+/)"

            if [ "$FILENAME" != /dev/null ]; then
              ((COUNT+=1))
              if [ $COUNT -gt 1 ]; then
                echo
              fi
              echo "  $FILENAME":"$RANGE"
              git --no-pager blame -s -L "$RANGE" HEAD "$FILENAME" 2>&1 | sed 's/^/  /'
            fi
            ;;
        esac
      done

      return 1
      ;;
  esac
}

# git rebase tracking
grt() {
  git rebase --interactive --keep-empty $(git merge-base HEAD $(_git_rebase_target)) "$@"
}

# git rebase branch
grb() {
  if git_current_branch | grep -q ^hotfix/; then
    local TARGET_BRANCH=origin/master
  else
    _git_assert_origin_head
    local TARGET_BRANCH=origin/HEAD
  fi
  git rebase --interactive --keep-empty $(git merge-base HEAD $TARGET_BRANCH) "$@"
}

# git cleanup
gcu() {
  if _git_assert_origin_head; then
    HEAD_NAME="$(git rev-parse --abbrev-ref origin/HEAD | sed 's/^origin\///')"
    git branch --merged origin/HEAD | grep -v '^\*' | awk '{print $1}' | grep -Fxv -e "$HEAD_NAME" -e develop -e master | xargs git branch -d
    git branch --remotes --merged origin/HEAD | grep -v origin/HEAD | grep '^ *origin/' | sed 's#^ *origin/##' | grep -v ^pr/ | grep -Fxv "$HEAD_NAME"
  fi
}

# git difftool show <ref> [path...]
gdts() {
  REF="${1:-HEAD}"
  shift
  git difftool "${REF}^..${REF}" "$@"
}

_gbr() {
  local CMD="$1"
  shift
  local LOCAL_HEAD="${1:-HEAD}"
  shift
  local REMOTE_HEAD="${1:-"@{u}"}"
  shift

  (
    set -e

    SCRATCH_DIR="$(mktemp -d -t gbr.XXXXXX)"
    trap '{ rm -rf "$SCRATCH_DIR"; }' EXIT

    _git_assert_origin_head
    LOCAL_RANGE="$(git merge-base origin/HEAD $LOCAL_HEAD)..$LOCAL_HEAD"
    UPSTREAM_RANGE="$(git merge-base origin/HEAD $REMOTE_HEAD)..$REMOTE_HEAD"

    $CMD "$LOCAL_RANGE" "$@" > "$SCRATCH_DIR/local"
    $CMD "$UPSTREAM_RANGE" "$@" > "$SCRATCH_DIR/upstream"

    chmod -w "$SCRATCH_DIR/local" "$SCRATCH_DIR/upstream"
    vimdiff "$SCRATCH_DIR/local" "$SCRATCH_DIR/upstream"
  )
}

_gbr_log() {
  git log --pretty='format:%h %s' --reverse "$@"
}

_gbr_diff() {
  (
    set -e
    set -o pipefail
    git diff "$@" | grep -v '^index'
  )
}

# git branch rebased log
alias gbrl='_gbr _gbr_log'
# git branch rebased diff
alias gbrd='_gbr _gbr_diff'
