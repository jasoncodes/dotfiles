xml() {
  xmllint -format - | if [ -t 1 ] && which pygmentize &> /dev/null; then
    pygmentize -l xml
  else
    cat
  fi
}

json() {
  (
    if which json_reformat &> /dev/null; then
      json_reformat # yajl
    else
      python -mjson.tool
    fi
  ) |
  sed 'h;s/[^ ].*//;s/    /  /g;G;s/\n *//' |
  perl -0pe 's/\[\n\n +\]/[]/g' |
  if [ -t 1 ] && which coderay &> /dev/null; then
    coderay -json
  else
    cat
  fi
}
