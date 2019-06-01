# Dotfiles

> This is my set of dotfiles for macOS that I use as a developer. It was carefully collected and organized by myself.  
  Inspired by [caarlos0 dotfiles](https://github.com/caarlos0/dotfiles), [hlissner dotfiles](https://github.com/hlissner/dotfiles/tree/master/shell/zsh) and [these instructions](https://sourabhbajaj.com/mac-setup/).

## Dependencies

* [`brew`](https://brew.sh): package-manager for macOS. It can be used to install command-line utilites as well as GUI apps.

## Installation
1. Clone this repo:

   ```bash
   cd ~
   git clone https://github.com/mitinarseny/dotfiles.git .dotfiles
   ```
1. Symlink `.zshrc` to your `~`:
   ```bash
   ln -s ~/.dotfiles/.zshrc
   ```
1. Install brew formulas and casks:

    ```bash
    cd ~/.dotfiles
    brew bundle
    ```
    
1. Prepare ZSH plugins:

    ```bash
    antibody bundle < ~/.dotfiles/.zsh_plugins.txt > ~/.dotfiles/.zsh_plugins.sh
    ```
    
1. Config [`bat`](https://github.com/sharkdp/bat):

    ```bash
    cd ~/.dotfiles/.bat/ && bat cache --source . --init
    ```
    
1. Allow JavaScript from Apple Events in Safari:
    In order to allow [BeardedSpice](https://github.com/beardedspice/beardedspice) to make it able to control streaming services, run this:
    ```bash
    defaults write -app Safari AllowJavaScriptFromAppleEvents 1
    ```

## Links
### Dictionary.app
Download additional dictionaries from [here](https://rutracker.org/forum/viewtopic.php?t=4264270)
