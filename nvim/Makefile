include ../utils.mk
.DEFAULT_GOAL :=

CONFIG_DIR   := $(HOME)/.config/nvim
BREW_FORMULA := neovim

DOTFILES := $(addprefix $(CONFIG_DIR)/,\
		init.vim \
		plugins.vim \
		coc-settings.json \
		$(wildcard ftplugin/*.vim) \
		$(wildcard spell/*.*.add) \
	)

.PHONY: dotfiles
dotfiles: $(DOTFILES)

$(DOTFILES): $(CONFIG_DIR)/%: %
	@mkdir -p $(@D)
	@ln -svf $(realpath $<) $@

.PHONY: install upgrade uninstall
ifeq (Darwin,$(UNAME))
install: | brew
	brew install $(BREW_FORMULA)

upgrade:
	brew upgrade $(BREW_FORMULA)

uninstall:
	brew uninstall $(BREW_FORMULA)
endif

.PHONY: lsp
lsp: $(addprefix lsp_,\
		clangd \
		gopls \
		pyls \
		yaml-language-server \
		vim-language-server \
		bash-language-server \
		docker-langserver \
	)

.PHONY: lsp_clangd
ifeq (Darwin,$(UNAME))
lsp_clangd: | brew
	brew install llvm
endif

.PHONY: clean
clean:
	$(RM) $(DOTFILES)

.PHONY: test
test:
	nvim --headless -c 'exit'
