MAS := 747648890

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

.PHONY: all
all: install

ifeq (Darwin, $(UNAME))
include ../macos/brew.mk
endif

.PHONY: install
ifeq (Darwin,$(UNAME))
install: | mas
	mas install $(MAS)
else
install:
	$(error only macOS is supported)
endif

.PHONY: uninstall
uninstall:
ifeq (Darwin,$(UNAME))
	mas uninstall $(MAS)
endif

