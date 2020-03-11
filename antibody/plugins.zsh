####### sindresorhus/pure #######
autoload -U promptinit; promptinit
prompt pure
export PURE_PROMPT_SYMBOL='λ'

####### zsh-users/zsh-autosuggest #######
# https://github.com/zsh-users/zsh-autosuggestions#enable-asynchronous-mode
ZSH_AUTOSUGGEST_USE_ASYNC=1

####### zdharma/fast-syntax-highlighting #######
# https://github.com/zdharma/fast-syntax-highlighting/issues/135#issuecomment-497452498
export FAST_HIGHLIGHT[whatis_chroma_type]=0

####### zsh-users/zsh-history-substring-search #######
[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   history-substring-search-up
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" history-substring-search-down
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=black,bg=cyan'
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=white,bg=red'

