BREW_FORMULAE := imagemagick

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

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

