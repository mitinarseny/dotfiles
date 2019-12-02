export FZF_COMPLETION_TRIGGER=','
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="
  --preview='(([[ -d {} ]] && tree -CFv --dirsfirst --noreport -L 2 {}) || (bat --decorations always --color always --style=plain {} || cat {}) 2> /dev/null) | head -n 200'
  --color fg:-1,bg:-1,hl:#EBCB8B,fg+:-1,bg+:-1,hl+:#EBCB8B
  --color info:#4C566A,prompt:#B48EAD,spinner:#8FBCBB,pointer:#8FBCBB,marker:#BF616A
  --cycle
  -1 -0
"
