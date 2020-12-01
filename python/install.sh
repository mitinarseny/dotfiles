#!/bin/sh -e

cd "$(dirname "$0")"

for i in */install.sh; do
  echo "---> $(dirname $i)"
  $i
done
