if command -v ssh-agent > /dev/null 2>&1 && [ -z "${SSH_AUTH_SOCK}" ]; then
  eval $(ssh-agent) > /dev/null
fi
