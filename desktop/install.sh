#!/bin/sh -e

xdg-desktop-menu install --novendor *.desktop

xdg-settings set default-web-browser Firefox.desktop
