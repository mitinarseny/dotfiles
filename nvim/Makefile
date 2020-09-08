CONFIG_DIR    := $(HOME)/.config/nvim
BREW_FORMULAE := neovim

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

.PHONY: all
all: dotfiles install

DOTFILES := $(addprefix $(CONFIG_DIR)/,\
		init.vim \
		plugins.vim \
		coc-settings.json \
		$(wildcard ftplugin/*) \
		$(wildcard spell/*.*.add) \
	)

.PHONY: dotfiles
dotfiles: $(DOTFILES)

$(DOTFILES): $(CONFIG_DIR)/%: %
	@mkdir -p $(@D)
	@ln -svf $(realpath $<) $@

ifeq (Darwin, $(UNAME))
include ../macos/brew.mk
endif

.PHONY: install
ifeq (Darwin,$(UNAME))
install: | brew
ifneq (,$(or $(findstring B,$(MAKEFLAGS)),$(if $(shell brew list --versions $(BREW_FORMULAE) 2> /dev/null),,B)))
	brew install $(BREW_FORMULAE)
endif
else
install:
	$(error only macOS is supported)
endif

.PHONY: upgrade
upgrade:
ifeq (Darwin,$(UNAME))
	brew upgrade $(BREW_FORMULAE)
endif

.PHONY: uninstall
uninstall:
ifeq (Darwin,$(UNAME))
	brew uninstall $(BREW_FORMULAE)
endif

.PHONY: clean
clean:
	$(RM) $(DOTFILES)

.PHONY: test
test:
	nvim --headless -c 'exit'
