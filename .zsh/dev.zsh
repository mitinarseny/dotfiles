# Golang
if [[ $(command -v go) ]]; then
    [[ ! -d "$HOME/dev/go" ]] && mkdir -p $HOME/dev/go
    export GOPATH=$HOME/dev/go
fi
