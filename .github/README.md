# dotfiles

```sh
$ git clone --bare https://github.com/mitinarseny/dotfiles ~/.dotfiles
$ alias dots="git --git-dir=~/.dotfiles --work-tree=~"
$ dots config --local status.showUntrackedFiles no
$ dots submodule update --init --recursive
$ dots checkout -f

$ git config --global --add include.path ~/.config/git/config.local
$ git config --global --add core.excludesfile ~/.config/git/excludes
```
