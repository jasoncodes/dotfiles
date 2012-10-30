# `editlast` opens the last modified file in the editor
editlast() {
  FILE="$(
    /usr/bin/find "${1:-.}" -type f \
      -not -regex '\./\..*' \
      -not -regex '\./tmp/.*' \
      -not -regex '\./log/.*' \
      -exec stat -c '%Y %n' {} +\; |
    sort -n | tail -1 | cut -d ' ' -f 2-
  )"
  "${EDITOR:-vi}" "$FILE"
}
