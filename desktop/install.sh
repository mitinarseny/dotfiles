#!/bin/sh -e

xdg-desktop-menu install --novendor firefox.desktop
xdg-settings set default-web-browser firefox.desktop
