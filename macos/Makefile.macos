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
	brew bundle -f $<

.PHONY: default_apps
default_apps: set-default-apps.sh default_apps.txt
	. set-default-apps.sh < default_apps.txt

.PHONY: ru_defaults
ru_defaults: set-defaults-ru.sh
	. set-defaults-ru.sh

