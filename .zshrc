_zpcompinit_custom() {
  setopt extendedglob local_options
  autoload -Uz compinit
  local zcd=${ZDOTDIR:-$HOME}/.zcompdump
  local zcdc="$zcd.zwc"
  # Compile the completion dump to increase startup speed, if dump is newer or doesn't exist,
  # in the background as this is doesn't affect the current session
  if [[ -f "$zcd"(#qN.m+1) ]]; then
        compinit -i -d "$zcd"
        { rm -f "$zcdc" && zcompile "$zcd" } &!
  else
        compinit -C -d "$zcd"
        { [[ ! -f "$zcdc" || "$zcd" -nt "$zcdc" ]] && rm -f "$zcdc" && zcompile "$zcd" } &!
  fi
}

source ~/.zsh_plugins.sh

_zpcompinit_custom

export ZSH_CONFIG_DIR=$HOME/.zsh

# Config enhancd
# if zplug check b4b4r07/enhancd; then
#     export ENHANCD_COMPLETION_BEHAVIOR=list
#     export ENHANCD_FILTER=fzf
# fi
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
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias zshrc='${=EDITOR} ~/.zshrc' # Quick access to the ~/.zshrc file
alias grep='grep --color'

# Functions
set -o extendedglob
for f ($ZSH_CONFIG_DIR/my_functions/*.zsh(N.))  . $f
