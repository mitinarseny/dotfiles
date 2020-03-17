# ZSH

> [ZSH](http://zsh.org) is POSIX-compatible shell designed for interactive use.

## Features

* integration with [`antibody`](../antibody)
* fast startup
  ```sh
  λ for i in {1..10}; do time zsh -i -c exit; done
  zsh -i -c exit  0.06s user 0.05s system 89% cpu 0.127 total
  zsh -i -c exit  0.06s user 0.05s system 91% cpu 0.120 total
  zsh -i -c exit  0.06s user 0.05s system 91% cpu 0.124 total
  zsh -i -c exit  0.06s user 0.05s system 92% cpu 0.120 total
  zsh -i -c exit  0.06s user 0.05s system 92% cpu 0.121 total
  zsh -i -c exit  0.06s user 0.05s system 91% cpu 0.122 total
  zsh -i -c exit  0.06s user 0.05s system 91% cpu 0.126 total
  zsh -i -c exit  0.06s user 0.05s system 91% cpu 0.122 total
  zsh -i -c exit  0.06s user 0.05s system 91% cpu 0.123 total
  zsh -i -c exit  0.06s user 0.05s system 91% cpu 0.119 total
  ```
* [aliases](aliases.zsh)
* [completion](completion.zsh)
* [functions](functions)
  * [`mkc some/dir`](functions/mkc): mkdir and cd
  * [`backup some/file`](functions/backup): move to `some/file~`

## Install

```sh
make
```
