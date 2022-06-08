if command -v ssh-agent > /dev/null && [ -z "${SSH_AUTH_SOCK}" ]; then
  eval "$(ssh-agent -s)" > /dev/null
  trap '[ -n "${SSH_AGENT_PID}" ] && eval $(ssh-agent -k)' 0
fi