# Init
export TERM="xterm-256color"
source $(brew --prefix)/share/antigen/antigen.zsh

# Dev
export GOPATH=$HOME/dev/go

# Functions
function mkc() {mkdir -p "$@" && cd "$@";}

export ZSH_AUTOSUGGEST_USE_ASYNC=true
export CASE_SENSITIVE=0
export CLICOLOR=1

# Tmux
# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_ITERM2=true

###############
### Antigen ###
###############



antigen use oh-my-zsh

antigen bundle brew
antigen bundle common-aliases
antigen bundle colorize
antigen bundle docker
antigen bundle docker-compose
antigen bundle git
antigen bundle golang
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
antigen bubdle zsh-users/zsh-completions

antigen bundle hlissner/zsh-autopair
antigen bundle zdharma/fast-syntax-highlighting

antigen bundle denysdovhan/gitio-zsh
antigen bundle marzocchi/zsh-notify

antigen apply

# Enable notifications
source ~/.antigen/bundles/marzocchi/zsh-notify/notify.plugin.zsh

# Enable iTerm Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Set some enviroment variables
export EDITOR=micro
export PAGER=most

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
