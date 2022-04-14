if command -v river > /dev/null && [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ] && [ "$(tty)" = '/dev/tty1' ]; then
  export SVDIR=${HOME}/.local/sv
  export XDG_SESSION_TYPE=wayland
  export XDG_CURRENT_DESKTOP=river
  exec dbus-run-session -- \
    env \
      XKB_DEFAULT_LAYOUT='us,ru' \
      XKB_DEFAULT_OPTIONS='grp:alt_space_toggle' \
    river
fi
