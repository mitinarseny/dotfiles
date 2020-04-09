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

$(DOTFILES): $(CONFIG_DIR)/%: % | $(CONFIG_DIR)
	@ln -svf $(realpath $<) $@

$(CONFIG_DIR):
	@mkdir -p $@

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

.PHONY: clean
clean:
	$(RM) $(DOTFILES)
