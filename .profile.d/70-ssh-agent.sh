if command -v ssh-agent > /dev/null && [ -z "${SSH_AUTH_SOCK}" ]; then
  eval "$(ssh-agent -s)" > /dev/null
  trap '[ -n "${SSH_AGENT_PID}" ] && eval $(ssh-agent -k)' 0
  if command -v ssh-add > /dev/null && [ "$(uname)" -eq 'Darwin' ]; then
    ssh-add --apple-load-keychain -q
  fi
fi
