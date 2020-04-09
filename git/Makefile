CONFIG_DIR    := ~/.config/git
BREW_FORMULAE := git
ifneq (,$(shell command -v nvim))
EDITOR := nvim
else
EDITOR := vim
endif

UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

ifeq (Darwin,$(UNAME))
CREDENTIALS_HELPER := osxkeychain
else
CREDENTIALS_HELPER := cache
endif



.PHONY: all
all: install dotfiles


.PHONY: install
ifeq (Darwin,$(UNAME))
install: | .brew
ifneq (,$(or $(findstring B,$(MAKEFLAGS)),$(if $(shell brew list --versions $(BREW_FORMULAE)),,B)))
	brew install $(BREW_FORMULAE)
endif
else
install:
	$(error only macOS is supported)
endif

.PHONY: uninstall
uninstall:
ifeq (Darwin,$(UNAME))
	brew uninstall $(BREW_FORMULAE)
endif

.PHONY: dotfiles
dotfiles: | $(CONFIG_DIR)/config
ifeq (,$(findstring $(realpath config.local),$(shell git config --global --get-all include.path)))
	git config --global --add include.path $(realpath config.local)
endif
ifeq (,$(findstring $(realpath excludes),$(shell git config --global --get-all core.excludesfile)))
	git config --global --add core.excludesfile $(realpath excludes)
endif
ifeq (,$(shell git config --global --get user.email))
	read -r -p 'GitHub author email: ' user_email; \
	git config --global user.email "$${user_email}"
endif
ifeq (,$(shell git config --global --get user.name))
	@read -r -p 'GitHub author name: ' user_name; \
	git config --global user.name "$${user_name}"
endif
ifneq ($(EDITOR),$(shell git config --global --get core.editor))
	git config --global core.editor $(EDITOR)
endif
ifneq ($(CREDENTIALS_HELPER),$(shell git config --global --get credential.helper))
	git config --global credential.helper $(CREDENTIALS_HELPER)
endif

$(CONFIG_DIR)/config:
	@mkdir -p $(@D)
	[ -e ~/.gitconfig ] && mv ~/.gitconfig $@ || touch $@


.PHONY: .brew
.brew:
ifeq (,$(shell command -v brew))
	$(MAKE) -C $(DOTFILES_ROOT)/macos brew
endif

.PHONY: clean
clean:
	git config --global --unset-all include.path '$(realpath config.local)'
	git config --global --unset-all core.excludesfile '$(realpath excludes)'
