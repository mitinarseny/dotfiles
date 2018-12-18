# Zsh
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

# Async ZSH
export ZSH_AUTOSUGGEST_USE_ASYNC=true

export CASE_SENSITIVE=0
export CLICOLOR=1

export LANG=${LANG:-en_US.UTF-8}

export PAGER="less -RF"
export EDITOR=micro
export LESS='-i -w -M -z-4'

# Less config
eval "$(SHELL=/bin/sh lesspipe.sh)"
export PYGMENTIZE_STYLE='monokai'

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