#!/usr/bin/env bash

<%=
  # This script will be embedded into the mtenv executable using ECR 
-%>

# If MTENV_HOME is not set, then set it to default, which is <%= MTENV::Default::HOME %>
if [ -z $MTENV_HOME ]; then
  export MTENV_HOME="<%= MTENV::Default::HOME %>" <% # This is where ECR comes in %>
fi

# Check active myst version
active_myst_version=`cat $MTENV_HOME/global` 2>&- # i.e. hide stderr output
if [ $? -ne 0 ]; then
  echo -e "\$MTENV_HOME/global does not exist, something has gone wrong with \`mtenv setup\`."
  echo -e "Try \`mtenv setup\`, if something goes wrong ask a myst/mtenv developer at https://github.com/myst-lang"
  exit 1
fi

# Check if $MTENV_HOME/global which is supposed to hold current version is empty
if [ -z $active_myst_version ]; then
  echo -e "No version of Myst is currently active."
  echo -e "\tRun \`mtenv versions\` to get a list of installed versions."
  echo -e "\tRun \`mtenv use <version>\` to set a global version."
  exit 1
fi

export MYST_HOME=$MTENV_HOME/versions/$active_myst_version

# Check that the executable actually exists before executing it
if [ ! -f $MYST_HOME/bin/myst ]; then
  echo -e "No myst executable found in MYST_HOME ($MYST_HOME)"
  echo -e "Try \`mtenv install $active_myst_version\`, and then \`mtenv use $active_myst_version\`"
  echo -e "If something goes wrong ask a myst/mtenv developer at https://github.com/myst-lang"
  exit 1
fi

# Proxy all arguments to the real executable
# Use exec to ensure same process pid and ownership
exec env $MYST_HOME/bin/myst $@
