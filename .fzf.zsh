# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

export FZF_DEFAULT_OPTS="
	--preview=\"(bat {} 2> /dev/null || tree -C {}) 2> /dev/null | head -200\"
	--color fg:-1,bg:-1,hl:#FFA759,fg+:-1,bg+:-1,hl+:#FFA759
	--color info:#5C6773,prompt:#D4BFFF,spinner:#95E6CB,pointer:#73D0FF,marker:#FF3333
	--cycle
	-1 -0
"