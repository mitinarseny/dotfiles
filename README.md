# Dotfiles

> This is my set of dotfiles for macOS that I use as a developer.  
  Inspired by [caarlos0 dotfiles](https://github.com/caarlos0/dotfiles), [hlissner dotfiles](https://github.com/hlissner/dotfiles/tree/master/shell/zsh) and [these instructions](https://sourabhbajaj.com/mac-setup/).

## Dependencies

* [`curl`](https://curl.haxx.se): command-line tool for transferring data with URLs
* [`brew`](https://brew.sh): package-manager for macOS
* [`git`](https://git-scm.com): cli for the most popular VCS today
  Install it with:
  ```bash
  brew install git
  ```
* [`dots`](https://github.com/mitinarseny/dots): delivery tool for dotfiles written in Go
  Install it with:
  ```bash
  brew install mitinarseny/tap/dots
  ```

## Installation
* Clone this repo:
  ```bash
  git clone https://github.com/mitinarseny/dotfiles.git ~/.dotfiles
  ```
* Up:
  ```bash
  dots up macos_full -c ~/.dotfiles/.dots.yaml
  ```
  
## Links
### Dictionary.app
Download additional dictionaries from [here](https://rutracker.org/forum/viewtopic.php?t=4264270)
