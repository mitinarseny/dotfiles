if command -v ssh-agent > /dev/null && [ -z "${SSH_AUTH_SOCK}" ]; then
  eval "$(ssh-agent -s)" > /dev/null
fi
