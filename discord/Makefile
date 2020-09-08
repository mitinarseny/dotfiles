BREW_CASK  := discord

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

.PHONY: all
all: install

ifeq (Darwin, $(UNAME))
include ../macos/brew.mk
endif

.PHONY: install
ifeq (Darwin,$(UNAME))
install: | brew
ifneq (,$(or $(findstring B,$(MAKEFLAGS)),$(if $(shell brew cask list --versions $(BREW_CASK) 2> /dev/null),,B)))
	brew cask install $(BREW_CASK)
endif
else
install:
	$(error only macOS is supported)
endif

.PHONY: upgrade
upgrade:
ifeq (Darwin,$(UNAME))
	brew upgrade --cask $(BREW_CASK)
endif

.PHONY: uninstall
uninstall:
ifeq (Darwin,$(UNAME))
	brew cask uninstall $(BREW_CASK)
endif
