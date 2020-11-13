include ../utils.mk
.DEFAULT_GOAL :=

BREW_CASK  := alacritty
CONFIG_DIR := $(HOME)/.config/alacritty
DOTFILES := $(addprefix $(CONFIG_DIR)/,\
	alacritty.yml \
	)

.PHONY: dotfiles
dotfiles: $(DOTFILES)

$(DOTFILES): $(CONFIG_DIR)/%: %
	@mkdir -p $(@D)
	@ln -svf $(realpath $<) $@

.PHONY: install upgrade uninstall
ifeq (Darwin,$(UNAME))
install: | brew
	brew cask install $(BREW_CASK)

upgrade:
	brew upgrade --cask $(BREW_CASK)

uninstall:
	brew cask uninstall $(BREW_CASK)
endif

.PHONY: clean
clean:
	$(RM) $(DOTFILES)
