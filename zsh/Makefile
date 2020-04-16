BREW_FORMULAE          := zsh
ANTIBODY_BREW_FORMULAE := getantibody/tap/antibody

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

.PHONY: all
all: dotfiles plugins install add-to-shells-db default-shell

DOTFILES := ~/.zshrc

.PHONY: dotfiles
dotfiles: $(DOTFILES)

~/.zshrc: zshrc
	@ln -svf $(realpath $<) $@

.PHONY: install
ifeq (Darwin,$(UNAME))
install: | .brew
ifneq (,$(or $(findstring B,$(MAKEFLAGS)),$(if $(shell brew list --versions $(BREW_FORMULAE)),,B)))
	brew install $(BREW_FORMULAE)
endif
else
install:
	$(error only macOS is supported)
endif

.PHONY: add-to-shells-db
add-to-shells-db: | install
ifeq (,$(shell grep "$$(command -v zsh)" /etc/shells))
	sudo sh -c 'echo $$(command -v zsh) >> /etc/shells'
endif

.PHONY: default-shell
default-shell: | add-to-shells-db
	chsh -s "$$(command -v zsh)"

PLUGINS := ~/.zsh_plugins.sh

.PHONY: plugins
plugins: $(PLUGINS)

~/.zsh_plugins.sh: plugins.txt | .antibody
	antibody bundle < $< > $@
ifeq (Darwin,$(UNAME))
	antibody bundle Homebrew/brew kind:fpath path:completions/zsh >> $@
endif

.PHONY: update
update: | .antibody
	antibody update

.PHONY: .antibody
ifeq (Darwin,$(UNAME))
.antibody: | .brew
ifeq (,$(shell command -v antibody 2> /dev/null))
	brew install $(ANTIBODY_BREW_FORMULAE)
endif
else
.antibody:
	curl --fail --silent --show-error --location git.io/antibody | sh -s - -b /usr/local/bin
endif

.PHONY: .brew
.brew:
ifeq (,$(shell command -v brew 2> /dev/null))
	$(MAKE) -C $(DOTFILES_ROOT)/macos brew
endif

.PHONY: uninstall
uninstall:
ifeq (Darwin,$(UNAME))
	brew uninstall $(BREW_FORMULAE)
endif

.PHONY: test
test: | dotfiles plugins install
	zsh -ic 'exit'

.PHONY: clean
clean:
	$(RM) $(DOTFILES) $(PLUGINS)
