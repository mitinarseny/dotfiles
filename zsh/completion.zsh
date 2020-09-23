setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt AUTO_PARAM_KEYS
setopt FLOW_CONTROL
setopt MAGIC_EQUAL_SUBST    # support completion after =

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

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
  zstyle ':completion:*:descriptions' format '-- %d --'
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

