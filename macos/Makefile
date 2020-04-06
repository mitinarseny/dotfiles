ifneq ($(shell uname -s),Darwin)
$(error not macOS)
endif

.PHONY: defaults
defaults: set-defaults.sh
	. set-defaults.sh

.PHONY: all
all: brew defaults default_apps

.PHONY: brew
brew: Brewfile
ifeq (,$(shell command -v brew))
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
endif
	brew bundle install --file $<

.PHONY: ru_defaults
ru_defaults: set-defaults-ru.sh
	. set-defaults-ru.sh

