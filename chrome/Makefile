BREW_CASK  := google-chrome

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

.PHONY: install
ifeq (Darwin,$(UNAME))
install: | .brew
ifneq (,$(or $(findstring B,$(MAKEFLAGS)),$(if $(shell brew cask list --versions $(BREW_CASK) 2> /dev/null),,B)))
	brew cask install $(BREW_CASK)
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
	brew cask uninstall $(BREW_CASK)
endif
