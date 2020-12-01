#!/bin/sh -e 

color () {
  local color=$1
  shift
  printf "$(tput setaf ${color})$*$(tput sgr0)"
}

log_info () {
  printf "$(color 2 "INFO:") $*" >&2
}

log_warning () {
  printf "$(color 3 "WARN:") $*" >&2
}

log_error () {
  printf "$(color 1 "ERROR:") $*" >&2
  exit 1
}


add_prefix () {
  local prefix=$1
  shift
  printf "${prefix}%s\n" $*
}

cannonicalize () {
  printf "%s/%s" $(dirname $1) $(basename $1)
}

remove () {
  for f in $*; do
    log_info "$(color 3 "[R]") $f\n"
    rm -f $f
  done
}

symlink () {
  local target=$1
  shift
  local sources
  sources="$(readlink -ev $*)"

  for s in ${sources}; do
    local t="$(cannonicalize "${target}$([ -d "${target}" ] && printf "/" && basename "$s")")"
    log_info "$(color 2 "[L]") $t -> $s\n"
    ln -sf "$s" "$t"
  done

  # ln -sfv ${sources} "${target}"
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
  log_info "Checking for '$1'... "
  executable $1 && color 2 "ok!\n" && return
  color 3 "not found!\n"
  log_info "Installing '$1'...\n"
  $2
  log_info "'$1' was installed!\n"
}

