PLUGINS_DIR=${XDG_DATA_HOME}/zsh/plugins

fpath+=( ${PLUGINS_DIR}/github.com/mafredri/zsh-async/async.zsh )

fpath+=( ${PLUGINS_DIR}/github.com/sindresorhus/pure )
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL='λ'
zstyle :prompt:pure:git:stash show yes
prompt pure
# zstyle ':prompt:pure:prompt:success' color cyan
export PATH="${PLUGINS_DIR}/github.com/paulirish/git-open:${PATH}"

if command -v fzf > /dev/null; then
  . ${PLUGINS_DIR}/github.com/Aloxaf/fzf-tab/fzf-tab.zsh
  command -v fzf > /dev/null
  FZF_TAB_FLAGS=(
      --ansi # Enable ANSI color support, necessary for showing groups
      --color=hl:2,bg+:8,gutter:-1,hl+:2,pointer:6,info:8,spinner:8,header:8,prompt:1,marker:1
      --expect='/,enter' # For continuous completion
      --nth=2,3 --delimiter='\x00' # Don't search prefix
      --layout=reverse --height="${FZF_TMUX_HEIGHT:=30}%" --min-height=12
      --tiebreak=begin -m --cycle
      --print-query
  )
  zstyle ':fzf-tab:*' fzf-flags $FZF_TAB_FLAGS
  zstyle ':fzf-tab:complete:*' fzf-bindings \
    'tab:down' \
    'btab:up' \
    'ctrl-space:toggle' \
    'change:top' \
    'backward-eof:abort'
  zstyle ':fzf-tab:*' continuous-trigger '/'
  zstyle ':fzf-tab:*' insert-space false
  # no prefix to indicate color
  zstyle ':fzf-tab:*:' prefix ''
  # white color is there is no group
  zstyle ':fzf-tab:*' default-color $'\033[37m'
  # do not show groups if only one available
  zstyle ':fzf-tab:*' single-group ''
fi
. ${PLUGINS_DIR}/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
# https://github.com/zsh-users/zsh-autosuggestions#enable-asynchronous-mode
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS="${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS} \
  key-right \
  key-end \
  key-end2 \
"
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS="${ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS} \
  key-cright \
  key-aright \
"

fpath+=( ${PLUGINS_DIR}/github.com/zsh-users/zsh-completions/src )

AUTOPAIR_INHIBIT_INIT=''
. ${PLUGINS_DIR}/github.com/hlissner/zsh-autopair/autopair.zsh
unset AUTOPAIR_INHIBIT_INIT

. ${PLUGINS_DIR}/github.com/zdharma/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
FAST_HIGHLIGHT[whatis_chroma_type]=0
FAST_HIGHLIGHT_STYLES[unknown-token]='fg=red'

. ${PLUGINS_DIR}/github.com/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=black,bg=cyan'
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=white,bg=red'

if command -v docker > /dev/null; then
  . ${PLUGINS_DIR}/github.com/mnowotnik/extra-fzf-completions/zsh/docker-fzf-completion.zsh
  fpath+=( ${PLUGINS_DIR}/github.com/docker/cli/contrib/completion/zsh )
fi

if command -v docker-compose > /dev/null; then
  fpath+=( ${PLUGINS_DIR}/github.com/docker/compose/contrib/completion/zsh )
fi

unset PLUGINS_DIR
