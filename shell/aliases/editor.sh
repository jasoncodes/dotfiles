# `editlast` opens the last modified file in the editor
editlast() {
  if stat --version 2>/dev/null| grep -q GNU; then
    STAT_OPTION='-c'
    STAT_FORMAT='%Y %n'
  else
    STAT_OPTION='-f'
    STAT_FORMAT='%m %N'
  fi
  FILE="$(
    git ls-files --cached --other --exclude-standard "$@" -z |
      xargs -0 stat "$STAT_OPTION" "$STAT_FORMAT" |
      sort -n | tail -1 | cut -d ' ' -f 2-
  )"
  "${EDITOR:-vi}" "$FILE"
}
