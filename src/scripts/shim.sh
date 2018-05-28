#!/usr/bin/env sh

if [ -z $MTENV_HOME ]; then
  mtenv_home=$MTENV_HOME
else
  mtenv_home="~/.mtenv"
fi

current_version=`cat ~/.mtenv/global`

if [ -z $current_version ]; then
  echo "No version of Myst is currently active."
  echo "Run \`mtenv use <version>\` to set a global version."
  exit
fi

executable_path="$mtenv_home/versions/$current_version/bin/myst"

# Proxy all arguments to the real executable
exec $executable_path $@
