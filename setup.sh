#!/usr/bin/env bash

export DOTFILES=~/.dotfiles

# symlink files
ln -sf $DOTFILES/.zshrc $DOTFILES/.config $DOTFILES/.gitconfig $DOTFILES/.gitexcludes $DOTFILES/.tmux.conf ~

# prepare zsh plugins
antibody bundle < $DOTFILES/.zsh_plugins.txt > $DOTFILES/.zsh_plugins.sh

# init bat cache
bat cache --source $DOTFILES/.bat --build

# setup iTerm2
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES/iterm2_profile"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# setup Sublime Text: symlink preferencies
ln -sf $DOTFILES/subl/Preferences.sublime-settings $DOTFILES/subl/Package\ Control.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/

# fix for BeardedSpice
defaults write -app Safari AllowJavaScriptFromAppleEvents 1