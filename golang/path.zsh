export GOPATH="${HOME}/dev/go"
[[ ! -d "${GOPATH}" ]] && mkdir -p "${GOPATH}"
export PATH="${PATH}:${GOPATH}/bin"
