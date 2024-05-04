if [ -d ${HOME}/.profile.d/ ]; then
  for f in ${HOME}/.profile.d/*.sh; do
    [ -r "${f}" ] && . "${f}"
  done
  unset f
fi

# use ~/.localrc for SUPER SECRET CRAP that you don't
# want in your public repo.
[ -r "${HOME}/.localrc" ] && . "${HOME}/.localrc"
