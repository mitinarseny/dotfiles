include ../inc.mk

.PHONY: all
all: install dotfiles install_language_servers make_fzf

CONFIG_DIR := $(XDG_CONFIG_HOME)/nvim

FILES := $(addprefix $(CONFIG_DIR)/,\
		$(wildcard *.vim lua/*.lua ftplugin/*.vim))

.PHONY: dotfiles
dotfiles: $(FILES) profiles

$(FILES): $(CONFIG_DIR)/%: %
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += neovim
else
install: | make_cmake
	TEMP_DIR=$$(mktemp -d) $(GIT_CLONE) https://github.com/neovim/neovim $${TEMP_DIR} && \
	  cd $${TEMP_DIR} && \
	  git checkout stable && \
	  make CMAKE_BUILD_TYPE=Release \
	  sudo make install; \
	  rm -rf $${TEMP_DIR}
endif

.PHONY: install_language_servers
install_language_servers: $(addprefix install_,clangd gopls pyright rust_analyzer)

.PHONY: install_gopls
install_gopls: | make_golang
	GONOPROXY=* go install golang.org/x/tools/gopls@latest

.PHONY: install_clangd
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install_clangd: | install_pkgs
ifneq (,$(filter void arch,$(DISTRO_ID)))
install_pkgs: PKGS += clang
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
install_pkgs: PKGS += clangd
endif
else
install_clangd: ; $(ERR_OS)
endif

.PHONY: install_pyright
install_pyright: | make_python
	pip install pyright

.PHONY: install_rust_analyzer
install_rust_anayzer:
	curl -fsSL https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-$(ARCH)-unknown-linux-$(LIBC).gz | \
		gunzip -c - > ~/.local/bin/rust-analyzer && \
		chmod +x ~/.local/bin/rust-analyzer
