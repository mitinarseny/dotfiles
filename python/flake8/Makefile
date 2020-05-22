CONFIG_DIR := $(HOME)/.config
PIP_PACKAGE := flake8

.PHONY: all
all: | dotfiles install

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
ifneq (,$(shell pip3 show --quiet $(PIP_PACKAGE) 2>&1))
	pip3 install $(PIP_PACKAGE)
endif

.PHONY: uninstall
uninstall:
ifeq (,$(shell pip3 show --quiet $(PIP_PACKAGE) 2>&1))
	pip3 uninstall --yes $(PIP_PACKAGE)
endif

.PHONY: clean
clean:
	$(RM) $(DOTFILES)
