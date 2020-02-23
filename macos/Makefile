ifneq ($(shell uname -s),Darwin)
	$(error not macOS)
endif

.PHONY: all
all: brew defaults default_apps

.PHONY: brew
brew: Brewfile
	brew bundle -f $<

.PHONY: defaults
defaults: set-defaults.sh
	. set-defaults.sh

.PHONY: ru_defaults
ru_defaults:
	. set-defaults-ru.sh

.PHONY: default_apps
default_apps: set-default-apps.sh default_apps.txt
	./set-default-apps.sh < default_apps.txt

