is_brew_formula_installed = $(shell brew list        --versions $(1) 2> /dev/null)
is_brew_cask_installed    = $(shell brew list --cask --versions $(1) 2> /dev/null)

# ifndef brew_formula
define brew_install
.PHONY: install

install:
	brew install $(1)
endef

define brew_upgrade
upgrade:
	brew upgrade $(1)
endef

define brew_formula
$(call brew_install,$(1))
$(call bre_upgrade,$(1))
endef

# endif

.PHONY: brew
brew:
ifeq (,$(shell command -v brew))
	curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
endif

.PHONY: mas
mas: | brew
ifeq (,$(shell command -v mas))
	brew install mas
endif
