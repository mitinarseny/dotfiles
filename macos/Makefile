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
	brew bundle install --file $<

.PHONY: ru_defaults
ru_defaults: set-defaults-ru.sh
	. set-defaults-ru.sh

