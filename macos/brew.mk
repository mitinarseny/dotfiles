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
