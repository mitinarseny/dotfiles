[[ $- == *i* ]] && [[ -r ${HOME}/.fzf/shell/completion.zsh ]] \
  && . ${HOME}/.fzf/shell/completion.zsh 2> /dev/null
[[ -r ~/.fzf/shell/key-bindings.zsh ]] \
  && . ~/.fzf/shell/key-bindings.zsh
