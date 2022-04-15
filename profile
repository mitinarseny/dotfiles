if [ -d ${HOME}/.profile.d/ ]; then
  for f in ${HOME}/.profile.d/*.sh; do
    [ -r "${f}" ] && . "${f}"
  done
  unset f
fi
