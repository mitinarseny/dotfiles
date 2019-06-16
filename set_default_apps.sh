#!/usr/bin/env bash
egrep -v "^\s*(#|$)" |
while IFS=$':' read extension role bundle_id; do
  # check if Bundle ID exists with lsregister
  [[ ! $(/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump | grep --color=never -o -m 1 "$bundle_id") ]] && echo "bundle id '$bundle_id' doesn't exist!" && continue
  [[ $role -eq "" ]] && role="all"
  duti -s $bundle_id .$extension $role && echo "*.$extension -> $(duti -x $extension | head -n 2 | tail -n 1) ($role)"
done