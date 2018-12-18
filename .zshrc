# Antigen 

source $(brew --prefix)/share/antigen/antigen.zsh

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
antigen bundle wfxr/forgit

antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

antigen bundle hlissner/zsh-autopair
antigen bundle zdharma/fast-syntax-highlighting

antigen bundle denysdovhan/gitio-zsh
antigen bundle marzocchi/zsh-notify

antigen bundle unixorn/autoupdate-antigen.zshplugin

antigen apply

# Source other files

ZSH_CONFIG_DIR=$HOME/.zsh
source $ZSH_CONFIG_DIR/config.zsh
source $ZSH_CONFIG_DIR/completion.zsh
source $ZSH_CONFIG_DIR/env.zsh
source $ZSH_CONFIG_DIR/aliases.zsh
source $ZSH_CONFIG_DIR/devenv.zsh
source $ZSH_CONFIG_DIR/keybinds.zsh
source $ZSH_CONFIG_DIR/functions.zsh

# Tmux

# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_ITERM2=true
