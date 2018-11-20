# Dev
export GOPATH=$HOME/dev/go

# Functions
function mkc() {mkdir -p "$@" && cd "$@";}


export TERM="xterm-256color"
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export CASE_SENSITIVE=0
export CLICOLOR=1


# Tmux
# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_ITERM2=true

###############
### Antigen ###
###############

source $(brew --prefix)/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle brew
antigen bundle common-aliases
antigen bundle colorize
antigen bundle docker
antigen bundle docker-compose
antigen bundle git
antigen bundle heroku
antigen bundle httpie
antigen bundle pip
antigen bundle python
antigen bundle redis-cli
antigen bundle sudo
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


