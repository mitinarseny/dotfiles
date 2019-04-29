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
antigen bundle psprint/zsh-cmd-architect

antigen bundle hlissner/zsh-autopair
antigen bundle zdharma/fast-syntax-highlighting

antigen bundle denysdovhan/gitio-zsh
antigen bundle marzocchi/zsh-notify

antigen bundle unixorn/autoupdate-antigen.zshplugin

antigen apply

# Tmux

# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_ITERM2=true

# ZSH config

unsetopt MAIL_WARNING		# Don't print a warning message if a mail file has been accessed.
setopt NOTIFY				# Report status of background jobs immediately.

setopt HIST_BEEP			# Beep when accessing non-existent history.

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD			# Push the old directory onto the stack on cd.

export WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

# Hitory
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

# Enable iTerm Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
zstyle ':notify:*' command-complete-timeout 10

# Completion
setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt AUTO_PARAM_KEYS
setopt FLOW_CONTROL
unsetopt MENU_COMPLETE

# bind UP and DOWN arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list '' \
       'm:{a-z\-}={A-Z\_}' \
       'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
       'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# iTermocil
compctl -g '~/.itermocil/*(:t:r)' itermocil

# Fuzzy finder
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# Async ZSH
export ZSH_AUTOSUGGEST_USE_ASYNC=true

export CASE_SENSITIVE=0
export CLICOLOR=1

export LANG=${LANG:-en_US.UTF-8}

export PAGER="less -RF"
export EDITOR=micro
export LESS='-i -w -M -z-4'

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\e[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
export LESS_TERMCAP_us=$'\e[04;38;5;146m' # begin underline

# Matplotlib inline graphics support
export MPLBACKEND="module://itermplot"

export TERM="xterm-256color"

# bat
export BAT_CONFIG_PATH=$HOME/.bat.conf

# Golang
export GOPATH=$HOME/dev/go

ZSH_CONFIG_DIR=$HOME/.zsh

# Aliases
alias tree='tree -C'

# Functions
set -o extendedglob
for f ($ZSH_CONFIG_DIR/my_functions/*.zsh(N.))  . $f

# Other completions
fpath=(
    $ZSH_CONFIG_DIR/completion/
    $fpath
)

autoload -U compinit 
compinit