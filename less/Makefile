include ../utils.mk
.DEFAULT_GOAL :=

BREW_FORMULAE := less

.PHONY: install upgrade uninstall
ifeq (Darwin,$(UNAME))
install: | brew
	brew install $(BREW_FORMULAE)

upgrade:
	brew upgrade $(BREW_FORMULAE)

uninstall:
	brew uninstall $(BREW_FORMULAE)
endif

