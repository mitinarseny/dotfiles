#!/bin/sh
# Usage: panel.sh <PANEL_WM_NAME>

PANEL_WM_NAME=$1

. ~/.config/nord/colors.sh

stream_datetime() {
  while
    date '+T%a %-d %b | %H:%M'
  do sleep 1; done
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
  rm -rf "${PANEL_FIFO}"
}
trap 'cleanup' INT TERM QUIT EXIT

for s in \
  "bspc subscribe report" \
  stream_datetime \
  "xtitle -sf X%s\n"
do
  $s > "${PANEL_FIFO}" &
done

panel() {
  while read -r line; do
    case $line in
      W*)
        wm=$(bspwm_report ${line#?})
        ;;
      T*)
        datetime=${line#?}
        ;;
      X*)
        title=${line#?}
        ;;
    esac
    printf "%s\n" "%{l}${wm}%{c}${title}%{r}${datetime} "
  done
}

panel < "${PANEL_FIFO}" \
  | lemonbar \
    -n "${PANEL_WM_NAME}" \
    -g "x24" \
    -B "${NORD0}" \
    -F "${NORD6}" \
  | sh &

wait
