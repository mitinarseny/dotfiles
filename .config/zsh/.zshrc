#!/bin/zsh

zmodload zsh/zprof

if [ -z "${ZDOTDIR}" ]; then
  if [ -z "${XDG_CONFIG_HOME}" ]; then
    export XDG_CONFIG_HOME="${HOME}/.config"
  fi
  export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
fi
[ -d "${ZDOTDIR}" ] || mkdir -p "${ZDOTDIR}"

unsetopt MAIL_WARNING       # Don't print a warning message if a mail file has been accessed.
setopt NOTIFY               # Report status of background jobs immediately.

setopt HIST_BEEP            # Beep when accessing non-existent history.
setopt HIST_FIND_NO_DUPS    # skip duplicate adjacent search results

unsetopt AUTO_CD            # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt AUTO_NAME_DIRS

setopt INTERACTIVE_COMMENTS # support for comments in command line mode

LANG=${LANG:-en_US.UTF-8}
WORDCHARS='*?_-~=&;!#$%^<>'

# Hitory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="${ZDOTDIR}/.zsh_history"
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt EXTENDED_HISTORY

CASE_SENSITIVE=0

_fix_cursor() {
   printf '\033[6 q'
}
precmd_functions+=(_fix_cursor)

alias ls='ls --color=auto' 2>/dev/null
alias l='ls -lFh'   2>/dev/null #size,show type,human readable
alias la='ls -lAFh' 2>/dev/null #long list,show almost all,show type,human readable
alias lr='ls -tRFh' 2>/dev/null #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh' 2>/dev/null #long list,sorted by date,show type,human readable
alias ll='ls -l'    2>/dev/null #long list

alias grep='grep --color' 2>/dev/null

alias tree='tree -C' 2>/dev/null

alias groot='git rev-parse --is-inside-work-tree > /dev/null 2>&1 && cd "$(git rev-parse --show-toplevel)"' 2>/dev/null

alias ip='ip -color' 2>/dev/null

alias tm='tmux new-session -A -s main' 2>/dev/null

alias tb='nc termbin.com 9999' 2>/dev/null

if [ -d "${HOME}/.dotfiles" ] \
  && command -v git > /dev/null \
  && [ "$(git -C ~/.dotfiles rev-parse --is-bare-repository 2>/dev/null)" = 'true' ]; then
  alias dots="git --git-dir=~/.dotfiles --work-tree=~"
fi

if [ -d ${XDG_DATA_HOME}/zsh/site-functions ] && [ -x ${XDG_DATA_HOME}/zsh/site-functions ]; then
  fpath+=( ${XDG_DATA_HOME}/zsh/site-functions )
  autoload -Uz ${XDG_DATA_HOME}/zsh/site-functions/*
fi

# load plugins
if [ -r "${ZDOTDIR}/plugins.zsh" ]; then
  . "${ZDOTDIR}/plugins.zsh"
fi

() { # init completion
  autoload -Uz compinit
  local zcd="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump"
  compinit -i -d "${zcd}"
  # recompile in background
  {
    autoload -Uz zrecompile
    zrecompile -qp \
      -R "${ZDOTDIR}/.zshrc" -- \
      -M "${zcd}"
  } &!
}


setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt AUTO_PARAM_KEYS
setopt FLOW_CONTROL
setopt MAGIC_EQUAL_SUBST    # support completion after =

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME}/zsh

# when new programs is installed, auto update autocomplete without reloading shell
zstyle ':completion:*' rehash true

# prevent cvs files/directories
zstyle ':completion:*(all-|)files' ignore-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignore-patterns '(*/)#CVS'

# case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list '' \
       'm:{a-z\-}={A-Z\_}' \
       'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
       'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'

# don't complete unavailable commands or complete functions.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

zstyle ':completion:*:*:*:*:*' menu select

# group mathces
zstyle ':completion:*:matches' group 'yes'

#default group name
zstyle ':completion:*' group-name ''

zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'


if [[ -v functions[fzf-tab-complete] ]]; then
  zstyle ':completion:*:descriptions' format '[%d]'
else
  zstyle ':completion:*'              format ' %F{yellow}-- %d --%f'
  zstyle ':completion:*:corrections'  format ' %F{green}-- %d (errors: %e) --%f'
  zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
  zstyle ':completion:*:messages'     format ' %F{purple} -- %d --%f'
  zstyle ':completion:*:warnings'     format ' %F{red}-- no matches found --%f'

  zstyle ':completion:*:default' list-prompt '%S%M matches%s'
fi

zstyle ':completion:*' verbose yes

# directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# separate sections for man pages
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true

# populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

zstyle ':completion:*:*:*:*:processes' command 'ps -e -o pid,user,cmd -w -w'

# do not highlight pasted text
zle_highlight=('paste:none')

# unbind vi mode
bindkey -r '\e'

# Ctrl+Z to bring back last suspended job
_zsh_cli_fg() { fg; }
zle -N _zsh_cli_fg
bindkey '^Z' _zsh_cli_fg

# https://stackoverflow.com/a/30899296
_r-delregion() {
  if ((REGION_ACTIVE)) then
     zle kill-region
  else
    local widget_name=$1
    shift
    zle $widget_name -- $@
  fi
}

_r-deselect() {
  ((REGION_ACTIVE = 0))
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

_r-select() {
  ((REGION_ACTIVE)) || zle set-mark-command
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

for key     seq        mode      widget (
    sleft   $'\e[1;2D' select    backward-char
    sright  $'\e[1;2C' select    forward-char
    sup     $'\e[1;2A' select    up-line-or-history
    sdown   $'\e[1;2B' select    down-line-or-history
    
    send    $'\e[1;2F' select    end-of-line
    send2   $'\e[4;2~' select    end-of-line

    shome   $'\e[1;2H' select    beginning-of-line
    shome2  $'\e[1;2~' select    beginning-of-line

    left    $'\e[D'    deselect  backward-char
    right   $'\e[C'    deselect  forward-char

    end     $'\E[F'    deselect  end-of-line
    end2    $'\e[4~'   deselect  end-of-line

    home    $'\E[H'    deselect  beginning-of-line
    home2   $'\e[1~'   deselect  beginning-of-line

    csleft  $'\e[1;6D' select    backward-word
    csright $'\e[1;6C' select    forward-word
    csend   $'\e[1;6F' select    end-of-line
    cshome  $'\e[1;6H' select    beginning-of-line

    cleft   $'\e[1;5D' deselect  backward-word
    aleft   $'\e[1;3D' deselect  backward-word
    cright  $'\e[1;5C' deselect  forward-word
    aright  $'\e[1;3C' deselect  forward-word

    del     $'\e[3~'   delregion delete-char
    bs      $'^?'      delregion backward-delete-char
  ) {
  functions[key-$key]="_r-$mode $widget"
  zle -N key-$key
  bindkey "${seq}" key-$key
}

bindkey '\e^?'    backward-kill-word



_r_copy() {
  if ((REGION_ACTIVE)) then
    zle copy-region-as-kill
  else
    zle vi-yank-whole-line
  fi
  if [ -n "${WAYLAND_DISPLAY}" ] && command -v wl-copy >/dev/null; then
    print -rn -- "${CUTBUFFER}" | wl-copy
  elif [ -n "${DISPLAY}" ] && command -v xclip >/dev/null; then
    print -rn -- "${CUTBUFFER}" | xclip -selection clipboard -i
  fi
}
zle -N _r_copy
_r_cut() {
  if ((REGION_ACTIVE)) then
    zle kill-region
  else
    zle kill-whole-line
  fi
  if [ -n "${WAYLAND_DISPLAY}" ] && command -v wl-copy >/dev/null; then
    print -rn -- "${CUTBUFFER}" | wl-copy
  elif [ -n "${DISPLAY}" ] && command -v xclip >/dev/null; then
    print -rn -- "${CUTBUFFER}" | xclip -selection clipboard -i
  fi
}
zle -N _r_cut

bindkey $'^Y' _r_copy
bindkey $'^E' _r_cut

# remove duplicated from PATH
typeset -U PATH

# less(1)
export LESS='-FSXiwMRj4a#4z-4'
if [ -n "${XDG_CURRENT_DESKTOP}" ]; then
  LESS+='--mouse --wheel-lines=2'
fi
