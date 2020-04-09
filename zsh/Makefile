BREW_FORMULAE          := zsh
ANTIBODY_BREW_FORMULAE := getantibody/tap/antibody

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

.PHONY: all
all: dotfiles install plugins

DOTFILES := ~/.zshrc

.PHONY: dotfiles
dotfiles: $(DOTFILES)

$(HOME)/.zshrc: zshrc
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
	grep "$$(command -v zsh)" /etc/shells > /dev/null || sudo sh -c 'echo $$(command -v zsh) >> /etc/shells'
	chsh -s "$$(command -v zsh)"

PLUGINS := ~/.zsh_plugins.sh

.PHONY: plugins
plugins: $(PLUGINS)

~/.zsh_plugins.sh: plugins.txt | .antibody
	antibody bundle < $< > $@
ifeq (Darwin,$(UNAME))
	antibody bundle Homebrew/brew kind:fpath path:completions/zsh >> $@
endif

.PHONY: .antibody
ifeq (Darwin,$(UNAME))
.antibody: | .brew
ifeq (,$(shell command -v antibody))
	brew install $(ANTIBODY_BREW_FORMULAE)
endif
else
.antibody:
	curl --fail --silent --show-error --location git.io/antibody | sh -s - -b /usr/local/bin
endif

.PHONY: .brew
.brew:
ifeq (,$(shell command -v brew))
	$(MAKE) -C $(DOTFILES_ROOT)/macos brew
endif

.PHONY: uninstall
uninstall:
ifeq (Darwin,$(UNAME))
	brew uninstall $(BREW_FORMULAE)
endif

.PHONY: clean
clean:
	$(RM) $(DOTFILES) $(PLUGINS)
