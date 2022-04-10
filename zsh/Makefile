include ../inc.mk

.PHONY: all
all: install dotfiles chsh

DOTFILES := $(addprefix $(HOME)/,.profile .zprofile .zshrc)
.PHONY: dotfiles
dotfiles: $(DOTFILES) profiles functions plugins

$(DOTFILES): $(HOME)/.%: %
	@$(LNS) $(realpath $<) $@

FUNCTIONS := $(addprefix $(XDG_DATA_HOME)/zsh/,$(wildcard site-functions/*))
.PHONY: functions
functions: $(FUNCTIONS)

$(FUNCTIONS): $(XDG_DATA_HOME)/zsh/%: %
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: plugins
plugins: $(HOME)/.plugins.zsh

PLUGINS_DIR := $(XDG_DATA_HOME)/zsh/plugins
GIT_PLUGINS := $(addprefix $(PLUGINS_DIR)/,\
	github.com/mafredri/zsh-async \
	github.com/sindresorhus/pure \
	github.com/paulirish/git-open \
	github.com/Aloxaf/fzf-tab \
	github.com/zsh-users/zsh-autosuggestions \
	github.com/zsh-users/zsh-completions \
	github.com/hlissner/zsh-autopair \
	github.com/zdharma/fast-syntax-highlighting \
	github.com/zsh-users/zsh-history-substring-search \
	github.com/mnowotnik/extra-fzf-completions \
	github.com/docker/cli \
	github.com/docker/compose \
)

$(HOME)/.plugins.zsh: plugins.zsh | $(GIT_PLUGINS) make_fzf
	@$(LNS) $(realpath $<) $@

$(GIT_PLUGINS): $(PLUGINS_DIR)/%:
	$(if $(wildcard $@),\
		$(GIT) -C $@ pull -q,\
		$(GIT_CLONE) https://$* $@)

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += zsh
else
install: ; $(ERR_OS)
endif

ZSH_COMMAND = $(shell command -v zsh)
.PHONY: chsh
chsh: | install add_to_shells
	[ "$$(getent passwd $(USER) | cut -d':' -f7)" = "$(ZSH_COMMAND)" ] || \
		sudo chsh -s $(ZSH_COMMAND)

.PHONY: add_to_shells
add_to_shells: /etc/shells | install
	grep -qxF $(ZSH_COMMAND) $< || echo $(ZSH_COMMAND) | sudo tee -a $< >/dev/null

