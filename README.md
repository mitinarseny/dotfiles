# Dotfiles

> This is my set of dotfiles for macOS that I use as a developer. It was carefully collected and organized by myself.  
  Inspired by [caarlos0 dotfiles](https://github.com/caarlos0/dotfiles), [hlissner dotfiles](https://github.com/hlissner/dotfiles/tree/master/shell/zsh) and [these instructions](https://sourabhbajaj.com/mac-setup/).

## Dependencies

* [`curl`](https://curl.haxx.se): cli for transferring data with URLs
* [`brew`](https://brew.sh): package-manager for macOS
* [`git`](https://git-scm.com): cli for the most popular VCS today
  Install it with 
  ```bash
  brew install git
  ```

## Installation
* Clone this repo:
  ```bash
  git clone https://github.com/mitinarseny/dotfiles.git ~/.dotfiles
  ```
* Symlink `.zshrc` and `.config/` to your `~`:
  ```bash
  ln -s ~/.dotfiles/.zshrc ~/.dotfiles/.config ~
  ```
* Install brew formulas and casks:
  ```bash
  brew bundle --file=~/.dotfiles/Brewfile
  ```
* Prepare ZSH plugins:
  ```bash
  antibody bundle < ~/.dotfiles/.zsh_plugins.txt > ~/.dotfiles/.zsh_plugins.sh
  ```
* Config [`bat`](https://github.com/sharkdp/bat):
  ```bash
  bat cache --source ~/.dotfiles/.bat --init
  ```  
* Allow JavaScript from Apple Events in Safari:  
  ```bash
  defaults write -app Safari AllowJavaScriptFromAppleEvents 1
  ```
  In order to allow [BeardedSpice](https://github.com/beardedspice/beardedspice) to control streaming services.
  
## Links
### Dictionary.app
Download additional dictionaries from [here](https://rutracker.org/forum/viewtopic.php?t=4264270)
