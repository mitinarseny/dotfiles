#!/bin/sh -e 

readonly DOTFILES_ROOT="$(git rev-parse --show-toplevel)"

readonly OS="$(uname -s)"

color () {
  local color=$1
  shift
  printf "$(tput setaf ${color})$*$(tput sgr0)"
}

info () {
  printf "$(color 2 "[INFO]") $*"
}

warning () {
  printf "$(color 3 "[WARN]") $*"
}

error () {
  printf "$(color 1 "[ERROR]") $*"
  exit 1
}

exe () {
  printf "$(color 2 "[$]") $*\n"
  $*
}

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
    
  [ -d "${target_dir}" ] || mkdir -p "${target_dir}"
  symlink $* 
}

executable () {
  command -v $* 2>&1 > /dev/null
}

ensure_installed () {
  info "checking for '$1'... "
  executable $1 && color 2 "ok\n" && return
  color 3 "not found\n"
  info "installing '$1'...\n"
  $2
}

install_os () {
  while [ "$#" -ge 2 ]; do
    [ "${OS}" != $1 ] && shift 2 && continue
    $2
    return
  done
  error "${OS} is not supported\n"
}

