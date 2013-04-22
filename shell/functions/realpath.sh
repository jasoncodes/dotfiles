function realpath()
{
  if readlink --version 2> /dev/null | grep -q GNU; then
    readlink -f "$@"
  else
    python -c 'import os,sys;print os.path.realpath(sys.argv[1])' "$@"
  fi
}
