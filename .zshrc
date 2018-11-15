export TERM="xterm-256color"

source $(brew --prefix)/share/antigen/antigen.zsh

###############
### Pligins ###
###############

# Auto-completions
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Tmux
# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_ITERM2=true

###############
### Antigen ###
###############

antigen use oh-my-zsh

antigen bundle brew
antigen bundle common-aliases
antigen bundle docker
antigen bundle docker-compose
antigen bundle git
antigen bundle heroku
antigen bundle httpie
antigen bundle osx
antigen bundle pip
antigen bundle python
antigen bundle redis-cli
antigen bundle sudo
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


