export XDG_CONFIG_HOME="$HOME/.config"

_zpcompinit_custom() {
  setopt extendedglob local_options
  autoload -Uz compinit
  local zcd=${ZDOTDIR:-$HOME}/.zcompdump
  local zcdc="$zcd.zwc"
  # Compile the completion dump to increase startup speed, if dump is newer or doesn't exist,
  # in the background as this is doesn't affect the current session
  if [[ -f "$zcd"(#qN.m+1) ]]; then
        compinit -i -d "$zcd"
        { rm -f "$zcdc" && zcompile "$zcd" } &!
  else
        compinit -C -d "$zcd"
        { [[ ! -f "$zcdc" || "$zcd" -nt "$zcdc" ]] && rm -f "$zcdc" && zcompile "$zcd" } &!
  fi
}

source .zsh_plugins.sh

_zpcompinit_custom

# Functions
set -o extendedglob
export ZSH_CONFIG_DIR=$HOME/.zsh

typeset -U config_files
config_files=($ZSH_CONFIG_DIR/**.zsh)

for file in ${(M)config_files:#**.zsh}; do
  source "$file"
done

unset config_files
