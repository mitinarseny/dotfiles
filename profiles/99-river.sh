if command -v river > /dev/null && [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ] && [ "$(tty)" = '/dev/tty1' ]; then
  env \
    XDG_SESSION_TYPE=wayland \
    XDG_CURRENT_DESKTOP=river \
    dbus-run-session -- \
    env \
      XKB_DEFAULT_LAYOUT='us,ru' \
      XKB_DEFAULT_OPTIONS='grp:alt_space_toggle' \
    river
  exit
fi
