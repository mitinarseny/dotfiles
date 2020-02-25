export FZF_COMPLETION_TRIGGER=','

if command -v fd > /dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

export FZF_DEFAULT_OPTS="\
  --color hl:2,bg+:8,hl+:2 \
  --color pointer:6,info:8,spinner:8,header:8,prompt:1,marker:1 \
  --cycle \
  --info=inline \
  -1 -0"
