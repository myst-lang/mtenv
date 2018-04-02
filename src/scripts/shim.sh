current_version=`cat ~/.mtenv/global`

if [ -z $current_version ]; then
  echo "No version of Myst is currently active."
  echo "Run \`mtenv use <version>\` to set a global version."
  exit
fi

executable_path="$HOME/.mtenv/versions/$current_version/bin/myst"

# Proxy all arguments to the real executable
$executable_path $@
