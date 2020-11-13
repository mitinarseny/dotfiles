include brew.mk
.DEFAULT_GOAL :=

.PHONY: all
all: brew defaults

.PHONY: defaults
defaults: set-defaults.sh
	. set-defaults.sh

.PHONY: ru_defaults
ru_defaults: set-defaults-ru.sh
	. set-defaults-ru.sh

.PHONY: brew-casks
brew-casks: Brewfile | brew
	brew bundle install --file $<

