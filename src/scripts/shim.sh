#!/usr/bin/env sh

# If MTENV_HOME is not set, then set it to default, which is '~/.mtenv'"
if [ -z $MTENV_HOME ]; then
  export MTENV_HOME="~/.mtenv"
fi

current_version=`cat $MTENV_HOME/global`

# check if $MTENV_HOME/global which is supposed to hold current version is empty
if [ -z $current_version ]; then
  echo "No version of Myst is currently active."
  echo "Run \`mtenv use <version>\` to set a global version."
  exit 1
fi

export MYST_HOME=$MTENV_HOME/versions/$current_version

# Proxy all arguments to the real executable
# Use exec to ensure same process
exec env $MYST_HOME/bin/myst $@
