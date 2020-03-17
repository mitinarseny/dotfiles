CONFIG_DIR := ~/.config/git

.PHONY: dotfiles
dotfiles: | $(CONFIG_DIR)/config
ifneq (true,$(shell git config --global --get dotfiles.managed))
	touch ~/.config/git/config
	git config --global include.path $(realpath config.local)
	git config --global core.excludesfile $(realpath excludes)
ifeq (,$(shell git config --global --get user.email))
	@read -r -p "GitHub author name: " user_name; \
	read -r -p "GitHyb author email: " user_email; \
	git config --global user.name "$${user_name}"; \
	git config --global user.email "$${user_email}"
else
	user_name="$$(git config --global --get user.name)"; \
	user_email="$$(git config --global --get user.email)"; \
	mv $${HOME}/.gitconfig $${HOME}/.gitconfig.backup; \
	git config --global user.name "$${user_name}"; \
	git config --global user.email "$${user_email}"
endif
	git config --global core.editor $$(command -v nvim > /dev/null 2>&1 && echo nvim || echo vim)
	git config --global dotfiles.managed "true"
ifeq ($(shell uname -s),Darwin)
	git config --global credential.helper osxkeychain
else
	git config --global credential.helper cache
endif
endif

$(CONFIG_DIR)/config:
	@mkdir -p $(@D)
	@touch $@
