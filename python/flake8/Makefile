CONFIG_DIR := $(HOME)/.config
PIP_PACKAGE := flake8

.PHONY: all
all: dotfiles

DOTFILES := $(addprefix $(CONFIG_DIR)/,\
	flake8 \
	)

.PHONY: dotfiles
dotfiles: $(DOTFILES)

$(DOTFILES): $(CONFIG_DIR)/%: %
	@mkdir -p $(@D)
	@ln -svf $(realpath $<) $@

.PHONY: install
install:
	pip3 install $(PIP_PACKAGE)

.PHONY: uninstall
uninstall:
	pip3 uninstall --yes $(PIP_PACKAGE)

.PHONY: clean
clean:
	$(RM) $(DOTFILES)
