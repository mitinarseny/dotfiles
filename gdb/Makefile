BREW_FORMULAE := gdb

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
ifneq (,$(or $(findstring B,$(MAKEFLAGS)),$(if $(shell brew list --versions $(BREW_FORMULAE)),,B)))
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

