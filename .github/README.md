# dotfiles

```sh
$ git clone --bare https://github.com/mitinarseny/dotfiles ~/.dotfiles
$ alias dots="git --git-dir=${HOME}/.dotfiles --work-tree=${HOME}"
$ dots submodule update --init --recursive
$ dots checkout -f
```
