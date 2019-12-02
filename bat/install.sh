#!/bin/sh

bat cache --build --source "$(dirname "$(readlink --canonicalize-existing "$0")")"
