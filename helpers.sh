#!/bin/sh -e 

readonly DOTFILES_ROOT="$(git rev-parse --show-toplevel)"
readonly OS="$(uname -s)"

add_prefix () {
  local prefix=$1
  shift
  printf "${prefix}%s\n" $*
}

symlink () {
  local target=$1
  shift
  local sources
  sources="$(readlink -ev $*)"

  ln -sfv ${sources} "${target}"
}

symlink_into_dir () {
  local target_dir=$1
    
  [ -d  "${target_dir}" ] || mkdir -p "${target_dir}"
  symlink $* 
}

executable () {
  command -v $* 2>&1 > /dev/null
}
