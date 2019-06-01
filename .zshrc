export ZSH_CONFIG_DIR=$HOME/.zsh
# ZPlug
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/golang", from:oh-my-zsh, ignore:oh-my-zsh.sh
zplug "plugins/heroku", from:oh-my-zsh
zplug "plugins/httpie", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/redis-cli", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", from:github, use:"pure.zsh", as:theme, on:"mafredri/zsh-async"
zplug "b4b4r07/enhancd", from:github, use:"init.sh", on:"junegunn/fzf-bin"
zplug "wfxr/forgit", from:github
zplug "zsh-users/zsh-history-substring-search", from:github
zplug "zsh-users/zsh-autosuggestions", from:github
zplug "zsh-users/zsh-completions", from:github
zplug "psprint/zsh-cmd-architect", from:github
zplug "hlissner/zsh-autopair", from:github, use:"autopair.zsh", defer:2
zplug "zdharma/fast-syntax-highlighting", from:github, use:"fast-syntax-highlighting.plugin.zsh"
zplug "denysdovhan/gitio-zsh", from:github, use:"gitio.plugin.zsh"
zplug "marzocchi/zsh-notify", from:github, use:"notify.plugin.zsh"
zplug "kwhrtsk/docker-fzf-completion", from:github, use:"docker-fzf.zsh", defer:2

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Docker completion
[ ! -f "$ZSH_CONFIG_DIR/completion/_docker" ] && curl -sL "https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker" > $ZSH_CONFIG_DIR/completion/_docker 
[ ! -f "$ZSH_CONFIG_DIR/completion/_docker-compose" ] && curl -sL "https://raw.githubusercontent.com/docker/compose/1.24.0/contrib/completion/zsh/_docker-compose" > $ZSH_CONFIG_DIR/completion/_docker-compose

fpath=(
    $ZSH_CONFIG_DIR/completion
    $fpath
)

zplug load

# Config enhancd
if zplug check b4b4r07/enhancd; then
    export ENHANCD_COMPLETION_BEHAVIOR=list
    export ENHANCD_FILTER=fzf
fi

# Enable iTerm Shell Integration
if [ ! -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
    curl -sL https://iterm2.com/misc/$(basename $SHELL)_startup.in -o $HOME/.iterm2_shell_integration.$(basename $SHELL)
fi
source $HOME/.iterm2_shell_integration.$(basename $SHELL)
zstyle ':notify:*' command-complete-timeout 10

# Config fzf
export FZF_COMPLETION_TRIGGER=','
export FZF_DEFAULT_OPTS="
    --preview=\"(bat {} || tree -L 2 -C {}) 2> /dev/null | head -200\"
    --color fg:-1,bg:-1,hl:#FFA759,fg+:-1,bg+:-1,hl+:#FFA759
    --color info:#5C6773,prompt:#D4BFFF,spinner:#95E6CB,pointer:#73D0FF,marker:#FF3333
    --cycle
    -1 -0
"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Check bat config
if [ -f "$HOME/.bat.conf" ]; then
    export BAT_CONFIG_PATH=$HOME/.bat.conf
else
    echo "[CONFIG_ERROR]: bat config does not exist!"
fi

# Golang
if [ -d "$HOME/dev/go" ]; then
    export GOPATH=$HOME/dev/go
else
    echo "[CONFIG_ERROR]: \$GOPATH does not exist!"
fi

# Tmux

# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_ITERM2=true

# ZSH config

unsetopt MAIL_WARNING		# Don't print a warning message if a mail file has been accessed.
setopt NOTIFY				# Report status of background jobs immediately.

setopt HIST_BEEP			# Beep when accessing non-existent history.

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD			# Push the old directory onto the stack on cd.

export WORDCHARS='*?_-[]~;!#%^(){}<>'

# Hitory
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

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

# Aliases
alias tree='tree -C'
alias tb="nc termbin.com 9999"

# Functions
set -o extendedglob
for f ($ZSH_CONFIG_DIR/my_functions/*.zsh(N.))  . $f
