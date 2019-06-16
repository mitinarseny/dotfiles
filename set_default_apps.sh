#!/usr/bin/env bash

# based on https://www.chainsawonatireswing.com/2012/09/19/changing-default-applications-on-a-mac-using-the-command-line-then-a-shell-script/
input="default.apps"
[[ ! -r "$input" ]] && echo "there is no file: $input" && exit
egrep -v "^\s*(#|$)" "$input" |
while IFS=$':' read extension bundle_id; do
  # check if Bundle ID exists
  [[ ! $(mdfind -onlyin ~/Applications -onlyin /Applications kMDItemCFBundleIdentifier = "$bundle_id") ]] && echo "bundle id '$bundle_id' doesn't exist!" && continue
  duti -s $bundle_id .$extension all && echo "*.$extension -> $bundle_id"
done