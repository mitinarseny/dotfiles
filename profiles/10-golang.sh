export GOPATH="${HOME}/dev/go"
[ -d "${GOPATH}" ] || mkdir -p "${GOPATH}"
if [ -d "${GOPATH}/bin" ]; then
  export PATH="${GOPATH}/bin:${PATH}"
fi
