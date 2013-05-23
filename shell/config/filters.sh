xml() {
  xmllint -format - | if [ -t 1 ] && which pygmentize &> /dev/null; then
    pygmentize -l xml
  else
    cat
  fi
}

json() {
  python -mjson.tool | if [ -t 1 ] && which coderay &> /dev/null; then
    coderay -json
  else
    cat
  fi
}
