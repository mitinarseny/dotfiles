CONFIG_DIR := $(HOME)/.config/alacritty
BREW_CASK  := alacritty

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)


.PHONY: all
all: dotfiles install

DOTFILES := $(addprefix $(CONFIG_DIR)/,\
	alacritty.yml \
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
ifneq (,$(or $(findstring B,$(MAKEFLAGS)),$(if $(shell brew cask list --versions $(BREW_CASK)),,B)))
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

.PHONY: clean
clean:
	$(RM) $(DOTFILES)
