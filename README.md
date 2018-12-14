# Dotfiles

My own collection of dotfiles for macOS.  
Inspired by [hlissner dotfiles](https://github.com/hlissner/dotfiles/tree/master/shell/zsh) and [these instructions](https://sourabhbajaj.com/mac-setup/).

## Homebrew

Install [brew](https://brew.sh).  
Install all required brew formulas and casks with:

```commandLine
brew bundle
```


## Copy
Copy files and directories to your `~` with this command:

```commandLine
cp -R ./.zshrc ./.tmux.conf ./.lessfilter ./.gitconfig ./.gitexcludes ./.config ./.zsh ~
```

## Config

### `bat`

```commandLine
cd ~/.bat/ && bat cache --source . --init
```

### Dictionary.app

Go [here](https://rutracker.org/forum/viewtopic.php?t=4264270) to download dictionaries.

### BeardedSpice: Mac Media Keys to Control Streaming Services

In Safari or Google Chrome go to `Dovelop -> Allow JavaScript from Apple Events`.