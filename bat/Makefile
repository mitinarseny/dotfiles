include ../utils.mk
.DEFAULT_GOAL :=

BREW_FORMULA := bat
CONFIG_DIR   := $(HOME)/.config/bat
DOTFILES := $(addprefix $(CONFIG_DIR)/,\
	config \
	)

.PHONY: dotfiles
dotfiles: $(DOTFILES)

$(DOTFILES): $(CONFIG_DIR)/%: %
	@mkdir -p $(@D)
	@ln -svf $(realpath $<) $@

.PHONY: install upgrade uninstall
ifeq (Darwin,$(UNAME))
install: | brew
	brew install $(BREW_FORMULA)

upgrade:
	brew upgrade $(BREW_FORMULA)

uninstall:
	brew uninstall $(BREW_FORMULA)
endif

.PHONY: cache
cache: | install
	bat cache --build --source $(CURDIR)

.PHONY: clean
clean:
	$(RM) $(DOTFILES)
