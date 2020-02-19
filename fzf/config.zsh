export FZF_COMPLETION_TRIGGER=','

if command -v fd > /dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

export FZF_DEFAULT_OPTS="
  --preview='(([[ -d {} ]] && tree -CFv --dirsfirst --noreport -L 2 {}) || (bat --decorations always --color always --style=plain {} || cat {}) 2> /dev/null) | head -n 200'
  --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C
  --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B
  --cycle
  --info=inline
  -1 -0
"
