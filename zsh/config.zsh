unsetopt MAIL_WARNING       # Don't print a warning message if a mail file has been accessed.
setopt NOTIFY               # Report status of background jobs immediately.

setopt HIST_BEEP            # Beep when accessing non-existent history.

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.

export LANG=${LANG:-en_US.UTF-8}
export WORDCHARS='*?_-[]~;!#%^(){}<>'

export EDITOR='vim'
export VEDITOR='code'
export PAGER="less"

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

# Tmux
# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_ITERM2=true
