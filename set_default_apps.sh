#!/bin/sh
egrep -v "^\s*(#|$)" |
while IFS=$':' read extension bundle_id role; do
  # check if Bundle ID exists with lsregister
  [[ ! $(/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump | grep --color=never -o -m 1 "$bundle_id") ]] && echo "bundle id '$bundle_id' doesn't exist!" && continue
  if [[ $role ]]; then
    duti -s $bundle_id .$extension $role &&
    echo "*.$extension -> $(duti -x $extension | head -n 2 | tail -n 1) ($role)"
  else
    duti -s $bundle_id $extension &&
    echo "$extension://* -> $bundle_id"
  fi
done