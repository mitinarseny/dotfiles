#!/bin/sh
# Usage: panel.sh <PANEL_WM_NAME>

PANEL_WM_NAME=$1

. ~/.config/nord/colors.sh

stream_sys() {
  local dt
  local sign
  local percent
  while
    dt=$(date '+%a %-d %b | %H:%M')
    percent=$(cat /sys/class/power_supply/BAT0/capacity)
    case $(cat /sys/class/power_supply/BAT0/status) in
      Charging|Full)
        sign=+
        ;;
      *)
        sign=
        ;;
    esac
    printf 'S%s%s%% %s\n' "${sign}" "${percent}" "${dt}"
  do sleep 0.9; done
}

bspwm_report() {
  IFS=':'; for i in $*; do
    item=$i
    name=${item#?}
    case $item in
      [mM]*)
        case $item in
          m*)
            # unfocused monitor
            ;;
          M*)
            # focused monitor
            ;;
        esac
        printf "%s" "%{A:bspc monitor --focus '${name}':} ${name} %{A}%{B-}%{F-}"
        ;;
      [fFoOuU]*)
        case $item in
          [FOU]*)
            printf "%s" "%{R}"
            ;;
          [fou]*)
            ;;
        esac
        printf "%s" "%{A:bspc desktop --focus '${name}':} ${name} %{A}%{B-}%{F-}%{-u}"
        ;;
      [LTG]*)
        printf " %s " "${name}"
        ;;
    esac
  done
}

PANEL_FIFO=$(mktemp --tmpdir --dry-run 'panel.XXX')
mkfifo "${PANEL_FIFO}"
cleanup() {
  trap - TERM
  kill 0
  rm -rf "${PANEL_FIFO}"
}
trap 'cleanup' INT TERM QUIT EXIT

for s in \
  stream_sys \
  "bspc subscribe report" \
  "xtitle -sf X%s\n"
do
  $s > "${PANEL_FIFO}" &
done

panel() {
  local wm
  local title
  local sys

  while read -r line; do
    case $line in
      W*)
        wm=$(bspwm_report ${line#?})
        ;;
      X*)
        title=${line#?}
        ;;
      S*)
        sys=${line#?}
        ;;
    esac
    printf "%s\n" "%{l}${wm}%{c}${title}%{r}${sys} "
  done
}

panel < "${PANEL_FIFO}" \
  | lemonbar \
    -n "${PANEL_WM_NAME}" \
    -g 'x30' \
    -f 'Fira Code:size=10' \
    -B "${NORD0}" \
    -F "${NORD6}" \
  | sh &

wait
