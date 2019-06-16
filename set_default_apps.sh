#!/usr/bin/env bash

# based on https://www.chainsawonatireswing.com/2012/09/19/changing-default-applications-on-a-mac-using-the-command-line-then-a-shell-script/
bundle_ids=$(/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump)
cat default.apps | grep . |
while IFS=$':' read extension bundle_id; do
  # Grep to see if Bundle ID exists, sending stdout to /dev/null
  echo $bundle_ids | grep $bundle_id > /dev/null
  # Save exit status (0=success & 1=failure)
  status=$?
  # If exit status failed, notify me & exit; if not, change default app for extension
  [[ ! $status -eq 0 ]] && echo "$bundle_id doesn't exist!" && continue
  duti -s $bundle_id .$extension all && echo ".$extension -> $bundle_id"
done