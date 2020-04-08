BREW_FORMULAE := bat
CONFIG_DIR   := ~/.config/bat

.PHONY: all
all: dotfiles install cache

DOTFILES = $(addprefix $(CONFIG_DIR)/,\
	config \
	)

.PHONY: dotfiles
dotfiles: $(DOTFILES)

$(CONFIG_DIR)/%: % | $(CONFIG_DIR)
	@ln -svf $(realpath $<) $@

$(CONFIG_DIR):
	@mkdir -p $@

.PHONY: install
install:
ifeq (,$(shell command -v bat))
ifeq (Darwin,$(shell uname -s))
	$(MAKE) -C $(CURDIR)/../brew install
	brew install $(BREW_FORMULAE)
else
	$(error only macOS is supported)
endif
endif

.PHONY: cache
cache: 
	bat cache --build --source $(CURDIR)

.PHONY: clean
clean:
	$(RM) $(DOTFILES)
