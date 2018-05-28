#!/usr/bin/env sh

if [ -z $MTENV_HOME ]; then
  export MTENV_HOME="~/.mtenv"
fi

current_version=`cat $MTENV_HOME/global`

if [ -z $current_version ]; then
  echo "No version of Myst is currently active."
  echo "Run \`mtenv use <version>\` to set a global version."
  exit 1
fi

export MYST_HOME=$MTENV_HOME/versions/$current_version

# Proxy all arguments to the real executable
exec env $MYST_HOME/bin/myst $@
