#!/bin/sh -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

ln -si "${SCRIPT_DIR}/gitconfig.local" "${HOME}/.gitconfig.local"
ln -si "${SCRIPT_DIR}/gitexcludes" "${HOME}/.gitexcludes"

if [ -z "$(git config --global --get user.email)" ]; then
	read -r -p "GitHub author name: " user_name
  read -r -p "GitHyb author email: " user_email
	git config --global user.name "${user_name}"
	git config --global user.email "${user_email}"
elif [ "$(git config --global --get dotfiles.managed)" != "true" ]; then
	# if user.email exists, let's check for dotfiles.managed config. If it is
	# not true, we'll backup the gitconfig file and set previous user.email and
	# user.name in the new one
	user_name="$(git config --global --get user.name)"
	user_email="$(git config --global --get user.email)"
	mv ${HOME}/.gitconfig ${HOME}/.gitconfig.backup
	git config --global user.name "${user_name}"
	git config --global user.email "${user_email}"
fi
# include the gitconfig.local file
git config --global include.path ~/.gitconfig.local
# finally make git knows this is a managed config already, preventing later
# overrides by this script
git config --global dotfiles.managed true

# Don't ask ssh password all the time
if [ "$(uname -s)" = "Darwin" ]; then
	git config --global credential.helper osxkeychain
else
	git config --global credential.helper cache
fi
