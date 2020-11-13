include ../utils.mk
.DEFAULT_GOAL :=

CONFIG_DIR    := ~/.config/git
BREW_FORMULAE := git

ifneq (,$(shell command -v nvim))
EDITOR := nvim
else
EDITOR := vim
endif

ifeq (Darwin,$(UNAME))
CREDENTIALS_HELPER := osxkeychain
else
CREDENTIALS_HELPER := cache
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


.PHONY: install upgrade uninstall
ifeq (Darwin,$(UNAME))
install: | brew
	brew install $(BREW_FORMULAE)

upgrade:
	brew upgrade $(BREW_FORMULAE)

uninstall:
	brew uninstall $(BREW_FORMULAE)
endif

.PHONY: clean
clean:
	git config --global --unset-all include.path '$(realpath config.local)'
	git config --global --unset-all core.excludesfile '$(realpath excludes)'
