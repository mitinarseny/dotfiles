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
export HISTFILE=$HOME/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

# Async ZSH
export ZSH_AUTOSUGGEST_USE_ASYNC=true

export CASE_SENSITIVE=0
export CLICOLOR=1

export LANG=${LANG:-en_US.UTF-8}

export EDITOR=micro
export LESS='-iwMRj4a#4z-4'
export PAGER="less -F"

# Less Colors for Man Pages
# Source: https://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
# More info: http://unix.stackexchange.com/a/108840
# Termcap: https://linux.die.net/man/5/termcap
# tput: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
export LESS_TERMCAP_md=$(tput bold; tput setaf 3)
export LESS_TERMCAP_me=$(tput sgr0)

# Matplotlib inline graphics support
export MPLBACKEND="module://itermplot"

# Config fzf
export FZF_COMPLETION_TRIGGER=','
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="
    --preview='([[ -f {} ]] && bat {} || ([[ -d {} ]] && tree -L 2 -C {})) | head -n 200'
    --color fg:-1,bg:-1,hl:#FFA759,fg+:-1,bg+:-1,hl+:#FFA759
    --color info:#5C6773,prompt:#D4BFFF,spinner:#95E6CB,pointer:#73D0FF,marker:#FF3333
    --cycle
    -1 -0
"

# Check bat config
[[ $(command -v bat) && -f "$HOME/.config/bat/config" ]] && export BAT_CONFIG_PATH="$HOME/.config/bat/config"

zstyle ':notify:*' command-complete-timeout 10

# Jupyter
[[ $(command -v jupyter) && -d "$HOME/.config/jupyter" ]] && export JUPYTER_CONFIG_DIR="$HOME/.config/jupyter"

# Tmux
# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_ITERM2=true
