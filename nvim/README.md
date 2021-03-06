# [NeoVim](https://neovim.io)

## Install

### Dotfiles

```sh
make dotfiles
```

### NeoVim

```sh
make install
```

## Commands

### Search

| Command | Description                               |
|:-------:|-------------------------------------------|
| `Files` | Search for files in project root          |
| `RG`    | Search for regex patterns in project root |

## Key Bindings

> **NOTE**: `<Leader>` is set to `,`

### Editing

| Normal       | Insert       | Visual       | Description                     |
|--------------|--------------|--------------|---------------------------------|
| `<A-BS>`     | `<A-BS>`     | -            | delete word backwards           |

#### Indentation

| Normal       | Insert       | Visual       | Description                     |
|--------------|--------------|--------------|---------------------------------|
| `=`          | -            | -            | autoindent current line         |
| `>>`         | `<C-t>`      | -            | indent current line             |
| `<<`         | `<C-d>`      | -            | unindent current line           |

#### Commenting

| Normal       | Insert       | Visual       | Description                        |
|--------------|--------------|--------------|------------------------------------|
| `<C-_><C-_>` | `<C-_><C-_>` | `<C-_><C-_>` | [un]comment current line/selection |

### Navigation

| Normal       | Insert       | Visual       | Description                                   |
|--------------|--------------|--------------|-----------------------------------------------|
| `<C-]>`      | `<C-]>`      | -            | go to tag/[LSP](#lsp) definition under cursor |
| `<C-o>`      | `<C-o><C-o>` | -            | go to previous location                       |
| `<C-i>`      | -            | -            | go to next location                           |

#### [FZF](https://github.com/junegunn/fzf.vim)

| Normal       | Insert       | Visual       | Description                     |
|--------------|--------------|--------------|---------------------------------|
| `<Leader>ff` | -            | -            | `:Files`                        |
| `<Leader>fr` | -            | -            | `:RG`                           |

### [LSP](https://github.com/prabirshrestha/vim-lsp)

| Normal       | Insert       | Visual       | Description        |
|--------------|--------------|--------------|--------------------|
| `<C-]>`      | `<C-]>`      | -            | go to definition   |
| `<Leader>lu` | -            | -            | show usages        |
| `<Leader>lr` | -            | -            | rename             |
| `<Leader>lh` | -            | -            | hover              |


### Spell


| Normal       | Insert       | Visual       | Description                             |
|:------------:|:------------:|:------------:|-----------------------------------------|
| `zg`         | -            | -            | add word under cursor to the dictionary |

