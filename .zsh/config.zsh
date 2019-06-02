unsetopt MAIL_WARNING       # Don't print a warning message if a mail file has been accessed.
setopt NOTIFY               # Report status of background jobs immediately.

setopt HIST_BEEP            # Beep when accessing non-existent history.

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.


export WORDCHARS='*?_-[]~;!#%^(){}<>'
export TERM="xterm-256color"

# Hitory
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

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
if [ -f "$DOTFILES/.bat.conf" ]; then
    export BAT_CONFIG_PATH=$DOTFILES/.bat.conf
else
    echo "[CONFIG_ERROR]: bat config does not exist!"
fi

zstyle ':notify:*' command-complete-timeout 10

# Jupyter
export JUPYTER_CONFIG_DIR=$DOTFILES/.jupyter

# Tmux
# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_ITERM2=true
