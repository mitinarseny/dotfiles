if command -v go >/dev/null; then
  if [ -n "$(go env GOBIN 2>/dev/null)" ]; then
    export PATH="$(go env GOBIN):${PATH}"
  elif [ -n "$(go env GOPATH 2>/dev/null)" ]; then
    export PATH="$(go env GOPATH)/bin:${PATH}"
  fi
fi
