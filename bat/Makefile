CONFIG_DIR    := $(HOME)/.config/bat
BREW_FORMULAE := bat

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

.PHONY: all
all: dotfiles install cache

DOTFILES := $(addprefix $(CONFIG_DIR)/,\
	config \
	)

.PHONY: dotfiles
dotfiles: $(DOTFILES)

$(DOTFILES): $(CONFIG_DIR)/%: % | $(CONFIG_DIR)
	@ln -svf $(realpath $<) $@

$(CONFIG_DIR):
	@mkdir -p $@

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

.PHONY: cache
cache: | install
	bat cache --build --source $(CURDIR)

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
