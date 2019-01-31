# mkdir and cd
function mkc() {mkdir -p "$@" && cd "$@";}

# get rid of styling in clipboard
function clcp() {pbpaste | cat | pbcopy;}