MAS := 747648890

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

.PHONY: install
ifeq (Darwin,$(UNAME))
install: | .mas
	mas install $(MAS)
else
install:
	$(error only macOS is supported)
endif

.PHONY: uninstall
uninstall:
ifeq (Darwin,$(UNAME))
	mas uninstall $(MAS)
endif

.PHONY: .mas
.mas: | .brew
ifeq (,$(shell command -v mas))
	brew install mas
endif

.PHONY: .brew
.brew:
ifeq (,$(shell command -v brew))
	$(MAKE) -C $(DOTFILES_ROOT)/macos brew
endif

