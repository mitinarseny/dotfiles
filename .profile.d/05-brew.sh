if ! command -v brew >/dev/null 2>&1; then
  export PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:${PATH}"
fi

if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi
