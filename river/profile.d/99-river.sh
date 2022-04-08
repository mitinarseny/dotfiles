if command -v river > /dev/null && [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ] && [ "$(tty)" = '/dev/tty1' ]; then
  exec dbus-run-session -- \
    env \
      SVDIR=${HOME}/.local/sv \
      XDG_SESSION_TYPE=wayland \
      XDG_CURRENT_DESKTOP=river \
      XKB_DEFAULT_LAYOUT='us,ru' \
      XKB_DEFAULT_OPTIONS='grp:alt_space_toggle' \
    river
fi
