# Golang
if [ -d "$HOME/dev/go" ]; then
    export GOPATH=$HOME/dev/go
else
    echo "[CONFIG_ERROR]: \$GOPATH does not exist!"
fi