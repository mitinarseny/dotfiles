ifneq (Darwin,$(shell uname -s))
$(error not macOS)
endif

.PHONY: all
all: brew defaults

.PHONY: defaults
defaults: set-defaults.sh
	. set-defaults.sh

.PHONY: ru_defaults
ru_defaults: set-defaults-ru.sh
	. set-defaults-ru.sh

.PHONY: brew
brew:
ifeq (,$(shell command -v brew))
	curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
endif

.PHONY: brew-casks
brew-casks: Brewfile | brew
	brew bundle install --file $<

