REQUIRED_FEATURES := else-if target-specific order-only undefine
MISSING_FEATURES  := $(filter-out $(filter $(REQUIRED_FEATURES),$(.FEATURES)),$(REQUIRED_FEATURES))
ifneq (,$(MISSING_FEATURES))
$(error Current make version does not support required features: $(MISSING_FEATURES))
endif
undefine REQUIRED_FEATURES
undefine MISSING_FEATURES

export UID ?= $(shell id -u)

export XDG_CONFIG_HOME ?= $(HOME)/.config
export XDG_CACHE_HOME  ?= $(HOME)/.cache
export XDG_DATA_HOME   ?= $(HOME)/.local/share
export XDG_STATE_HOME  ?= $(HOME)/.local/state
export XDG_RUNTIME_DIR ?= /run/user/$(UID)

LNS := ln -sfv
GIT := git
GIT_CLONE = $(GIT) clone -q

ARCH := $(shell uname -m)
ifeq (i386,$(ARCH))
ARCH := x86
else ifeq (aarch64_be,$(ARCH))
ARCH := aarch64
endif
ERR_ARCH = $(error Unsupported arch: "$(ARCH)")

LIBC := gnu
ifneq (,$(shell ldd --version 2>&1 | grep -F musl))
LIBC := musl
endif

KERNEL := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ERR_KERNEL = $(error Unsupported kernel: "$(KERNEL)")

ifeq (linux,$(KERNEL))
.os_release := $(firstword $(wildcard /etc/os-release /usr/lib/os-release))
ifneq (,$(.os_release))
DISTRO_ID := $(shell . $(.os_release) && echo $${ID})
else
$(warning Unable to detect Linux OS)
DISTRO_ID := linux
endif
undefine .os_release
else ifeq (darwin,$(KERNEL))
DISTRO_ID := macos
endif

.PHONY: all
all: profiles services XDG_RUNTIME_DIR \
	alacritty \
	cmake \
	firefox \
	fonts \
	foot \
	fzf \
	git \
	golang \
	inputrc \
	less \
	mako \
	nord \
	nvim \
	pipewire \
	python \
	river \
	rust \
	ssh \
	tmux \
	waylock \
	wob \
	yambar \
	zsh


XBPS_INSTALL   := sudo xbps-install -Su --yes
PACMAN_INSTALL := sudo pacman -Sy --noconfirm
DEB_INSTALL    := sudo apt-get update && sudo apt-get install --yes

ERR_OS = $(error Unsupported OS: "$(DISTRO_ID)")

PKGS_INSTALL    =  $(ERR_OS)
ifeq (void,$(DISTRO_ID))
PKGS_INSTALL := $(XBPS_INSTALL)
else ifeq (arch,$(DISTRO_ID))
PKGS_INSTALL := $(PACMAN_INSTALL)
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
PKGS_INSTALL := $(DEB_INSTALL)
.PHONY: _install.software-properties-common
_install.software-properties-common:
	$(DEB_INSTALL) software-properties-common
.PHONY: _install.add-apt-repository
_install.add-apt-repository: _install.software-properties-common
	$(eval ADD_APT_REPOSITORY := sudo add-apt-repository)
endif

.PHONY: profiles
PROFILES := $(addprefix profile.,$(notdir $(wildcard profiles/[0-9][0-9]-*.sh)))
profiles: $(PROFILES)

.PHONY: $(PROFILES)
$(PROFILES): profile.%: $(HOME)/.profile.d/%

$(HOME)/.profile.d/%: profiles/% | $(HOME)/.profile
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

$(HOME)/.profile: profile
	@$(LNS) $(realpath $<) $@


export SVDIR := $(HOME)/.local/sv
SV_FILES := run finish check down log/run log/finish

.PHONY: runit
runit:
ifneq (,$(filter void ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) runit socklog
else
	$(ERR_OS)
endif

.PHONY: services
SERVICES := $(patsubst sv/%/run,service.%,$(wildcard sv/*/run))
services: $(SERVICES)

define SERVICE_tmpl
.PHONY: service.$(1)
service.$(1): $(patsubst sv/%,$(SVDIR)/%,$(wildcard $(addprefix sv/$(1)/,$(SV_FILES)))) | runit
endef
$(foreach s,$(patsubst service.%,%,$(SERVICES)),$(eval $(call SERVICE_tmpl,$(s))))

$(SVDIR)/%/run: sv/%/run | $(SVDIR)/%/supervise
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

$(SVDIR)/%/finish: sv/%/finish
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

$(SVDIR)/%/check: sv/%/check
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

$(SVDIR)/%/down: sv/%/down
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PRECIOUS: $(SVDIR)/%/supervise
$(SVDIR)/%/supervise:
	@mkdir -p $(dir $@)
	@$(LNS) $(XDG_RUNTIME_DIR)/supervise.$* $@

.PRECIOUS: $(SVDIR)/%/log/supervise
$(SVDIR)/%/log/supervise:
	@mkdir -p $(dir $@)
	@$(LNS) $(XDG_RUNTIME_DIR)/supervise.$*-log $@


.PHONY: alacritty
alacritty: $(addprefix alacritty.,install dotfiles)

ALACRITTY_CONFIG_DIR := $(XDG_CONFIG_HOME)/alacritty

.PHONY: alacritty.dotfiles
alacritty.dotfiles: $(ALACRITTY_CONFIG_DIR)/alacritty.yml

$(ALACRITTY_CONFIG_DIR)/alacritty.yml: alacritty/alacritty.yml | tmux fonts
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: alacritty.install
ifneq (,$(filter void arch,$(DISTRO_ID)))
alacritty.install:
	$(PKGS_INSTALL) alacritty
else
alacritty.install: | rust.install
	cargo install alacritty
endif

CMAKE_VERSION ?= 3.32.0
CMAKE_GITHUB_RELEASE := https://github.com/Kitware/CMake/releases/download/v$(CMAKE_VERSION)
.PHONY: cmake
cmake:
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) cmake
else ifeq (linux,$(KERNEL))
	curl -fsSL $(CMAKE_GITHUB_RELEASE)/cmake-$(CMAKE_VERSION)-linux-$(ARCH).tar.gz | \
		sudo tar -xzv --strip 1 -C /usr/local
else ifeq (darwin,$(KERNEL))
	curl -fsSL $(CMAKE_GITHUB_RELEASE)/cmake-$(CMAKE_VERSION)-macos-universal.tar.gz | \
		sudo tar -xzv --strip 1 -C /usr/local
else
	$(ERR_KERNEL)
endif

.PHONY: firefox
firefox:
ifneq (,$(filter void arch ubuntu,$(DISTRO_ID)))
	$(PKGS_INSTALL) firefox
else ifeq (debian,$(DISTRO_ID))
	$(PKGS_INSTALL) firefox-esr
else
	$(ERR_OS)
endif

FONTCONFIG_CONFIG_DIR := $(XDG_CONFIG_HOME)/fontconfig
FONTS_DIR := $(XDG_DATA_HOME)/fonts

.PHONY: fonts
fonts: $(addprefix fonts.,install config cache)

.PHONY: fonts.config
fonts.config: $(FONTCONFIG_CONFIG_DIR)/fonts.conf fonts.cache

$(FONTCONFIG_CONFIG_DIR)/fonts.conf: fonts/fonts.conf
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: fonts.install
fonts.install: | $(addprefix _fonts.install.,fontconfig \
	firacode \
	) fonts.cache

.PHONY: _fonts.install.fontconfig
_fonts.install.fontconfig:
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) fontconfig
else
	$(ERR_OS)
endif

.PHONY: fonts.cache
fonts.cache: _fonts.install.fontconfig
	fc-cache --force --verbose

.PHONY: _fonts.install.firacode
ifneq (,$(filter void arch,$(DISTRO_ID)))
_fonts.install.firacode:
ifeq (void,$(DISTRO_ID))
	$(PKGS_INSTALL) font-firacode
else ifeq (arch,$(DISTRO_ID))
	$(PKGS_INSTALL) ttf-fira-code
endif
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
_fonts.install.firacode: | _install.add-apt-repository
ifeq (ubuntu,$(DISTRO_ID))
	$(ADD_APT_REPOSITORY) universe
else ifeq (debian,$(DISTRO_ID))
	$(ADD_APT_REPOSITORY) contrib
endif
	$(PKGS_INSTALL) fonts-firacode
else
FIRACODE_VERSION := 6.2
FIRACODE_ZIP := Fira_Code_v$(FIRACODE_VERSION).zip
_fonts.install.firacode:
	curl -fsSLO --output-dir /tmp https://github.com/tonsky/FiraCode/releases/download/$(FIRACODE_VERSION)/$(FIRACODE_ZIP)
	@mkdir -p $(FONTS_DIR)
	unzip -o -q -d $(FONTS_DIR) /tmp/$(FIRACODE_ZIP)
	@rm -f /tmp/$(FIRACODE_ZIP)
endif


FOOT_CONFIG_DIR := $(XDG_CONFIG_HOME)/foot

.PHONY: foot
foot: $(addprefix foot.,install dotfiles) service.foot

.PHONY: foot.dotfiles
foot.dotfiles: $(FOOT_CONFIG_DIR)/foot.ini

$(FOOT_CONFIG_DIR)/%.ini: foot/%.ini
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: foot.install
foot.install:
ifneq (,$(filter void arch,$(DISTRO_ID)))
	$(PKGS_INSTALL) foot
else
	$(ERR_OS)
endif

.PHONY: fzf
fzf:
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) fzf
else
	$(ERR_OS)
endif

.PHONY: git
git: $(addprefix git.,install include set_user set_credential_helper)

.PHONY: git.include_files
git.include: $(addprefix git.include.,config_local excludes)

GIT_CONFIG_GLOBAL := git config --global

.PHONY: git.include_files.config_local
git.include.config_local: git/config.local
ifeq (,$(shell $(GIT_CONFIG_GLOBAL) --get include.path "$(realpath git/config.local)"))
	$(GIT_CONFIG_GLOBAL) --add include.path "$(realpath $<)"
endif

.PHONY: git.include.excludes
git.include.excludes: git/excludes
ifeq (,$(shell $(GIT_CONFIG_GLOBAL) --get core.excludesfile "$(realpath git/excludes)"))
	$(GIT_CONFIG_GLOBAL) --add core.excludesfile "$(realpath $<)"
endif

GIT_CREDENTIAL_HELPER := cache
ifeq (darwin,$(KERNEL))
GIT_CREDENTIAL_HELPER := osxkeychain
endif
.PHONY: git.set_credential_helper
git.set_credential_helper:
ifeq (,$(shell $(GIT_CONFIG_GLOBAL) --get credential.helper))
	$(GIT_CONFIG_GLOBAL) credential.helper $(GIT_CREDENTIAL_HELPER)
endif

define GIT.SET_USER_tmpl
.PHONY: git.set_user.$(1)
git.set_user.$(1):
ifeq (,$$(shell $$(GIT_CONFIG_GLOBAL) --get user.$(1)))
	read -r -p 'GitHub user $(1): ' user_$(1) && $$(GIT_CONFIG_GLOBAL) user.$(1) "$${user_$(1)}"
endif
endef
$(foreach key,email name,$(eval $(call GIT.SET_USER_tmpl,$(key))))

.PHONY: git.set_user
git.set_user: $(addprefix git.set_user.,email name)

.PHONY: git.install
git.install:
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) git
else
	$(ERR_OS)
endif


.PHONY: golang
golang: golang.install profile.10-golang.sh

GO_VERSION ?= 1.18
ifeq (x86_64,$(ARCH))
GOARCH := amd64
else ifeq (x86,$(ARCH))
GOARCH := 386
else ifeq (aarch64,$(ARCH))
GOARCH := arm64
else
GOARCH = $(ERR_ARCH)
endif
.PHONY: golang.install
golang.install:
ifneq (,$(filter void arch,$(DISTRO_ID)))
	$(PKGS_INSTALL) go
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) golang
else
	-@sudo rm -rf /usr/local/go
	curl -fsSL https://go.dev/dl/go$(GO_VERSION).$(KERNEL)-$(GOARCH).tar.gz | \
		sudo tar -xzv -C /usr/local
endif


.PHONY: inputrc
inputrc: $(HOME)/.inputrc

$(HOME)/.inputrc: inputrc/inputrc
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@


.PHONY: less
less: less.install profile.10-less.sh

.PHONY: less.install
less.install:
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) less
else
	$(ERR_OS)
endif


.PHONY: mako
mako: $(addprefix mako.,install dotfiles) service.mako

MAKO_CONFIG_DIR := $(XDG_CONFIG_HOME)/mako

.PHONY: mako.dotfiles
mako.dotfiles: $(MAKO_CONFIG_DIR)/config

$(MAKO_CONFIG_DIR)/config: mako/config
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@


.PHONY: mako.install
mako.install:
ifneq (,$(filter void arch,$(DISTRO_ID)))
	$(PKGS_INSTALL) mako
else ifeq (ubuntu,$(DISTRO_ID))
	$(PKGS_INSTALL) mako-notifier
else
	$(ERR_OS)
endif

NORD_CONFIG_DIR := $(XDG_CONFIG_HOME)/nord

.PHONY: nord
nord: $(NORD_CONFIG_DIR)/colors.sh

$(NORD_CONFIG_DIR)/colors.sh: nord/colors.sh
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@


.PHONY: nvim
nvim: $(addprefix nvim.,install dotfiles) profile.10-nvim.sh lsp

.PHONY: nvim.dotfiles
NVIM_DOTFILES := $(addprefix $(XDG_CONFIG_HOME)/,$(wilcarrd nvim/*.vim nvim/lua/*.lua nvim/ftplugin/*.vim))
nvim.dotfiles: $(NVIM_DOTFILES)

$(NVIM_DOTFILES): $(XDG_CONFIG_HOME)/%: %
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: nvim.install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
nvim.install:
	$(PKGS_INSTALL) neovim
else
nvim.install: | cmake
	TEMP_DIR=$$(mktemp -d) $(GIT_CLONE) https://github.com/neovim/neovim $${TEMP_DIR} && \
	  cd $${TEMP_DIR} && \
	  git checkout stable && \
	  make CMAKE_BUILD_TYPE=Release \
	  sudo make install; \
	  rm -rf $${TEMP_DIR}
endif

.PHONY: lsp
lsp: $(addprefix lsp.,clangd gopls pyright rust_analyzer)

.PHONY: lsp.gopls
lsp.gopls: | golang
	GONOPROXY=* go install golang.org/x/tools/gopls@latest

.PHONY: lsp.clangd
lsp.clangd: $(addprefix lsp.clangd.,install dotfiles)

.PHONY: lsp.clangd.dotfiles
CLANGD_CONFIG_DIR := $(XDG_CONFIG_HOME)/clangd
lsp.clangd.dotfiles: $(CLANGD_CONFIG_DIR)/config.yaml

$(CLANGD_CONFIG_DIR)/config.yaml: clangd/config.yaml
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: lsp.clangd.install
lsp.clangd.install:
ifneq (,$(filter void arch,$(DISTRO_ID)))
	$(PKGS_INSTALL) clang
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) clangd
else
	$(ERR_OS)
endif

.PHONY: lsp.pyright
lsp.pyright: | python
	pip3 install pyright

.PHONY: lsp.rust_analyzer
lsp.rust_analyzer: | profile.00-xdg.sh
	curl -fsSL https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-$(ARCH)-unknown-linux-$(LIBC).gz | \
		gunzip -c - > ~/.local/bin/rust-analyzer && \
		chmod +x ~/.local/bin/rust-analyzer


.PHONY: pipewire
pipewire: pipewire.install service.pipewire

.PHONY: pipewire.install
pipewire.install:
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) pipewire
else
	$(ERR_OS)
endif


.PHONY: python
python:
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) python3
else
	$(ERR_OS)
endif


.PHONY: river
river: $(addprefix river.,install dotfiles) profile.99-river.sh

RIVER_CONFIG_DIR := $(XDG_CONFIG_HOME)/river

.PHONY: river.dotfiles
river.dotfiles: $(RIVER_CONFIG_DIR)/init

$(RIVER_CONFIG_DIR)/init: river/init | runit \
	alacritty \
	foot \
	mako \
	nord \
	pipewire \
	waylock \
	wob \
	yambar
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: river.install
ifeq (void,$(DISTRO_ID))
	$(PKGS_INSTALL) river xdg-desktop-portal-wlr
else
	$(ERR_OS)
endif


.PHONY: rust
rust: rust.install profile.10-cargo.sh

.PHONY: rust.install
rust.install:
ifeq (,$(shell command -v rustup))
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
		sh -s -- -y --no-modify-path
else
	rustup self update
endif


.PHONY: ssh
ssh: ssh.install profile.70-ssh-agent.sh

.PHONY: ssh.install
ssh.install:
ifneq (,$(filter void arch,$(DISTRO_ID)))
	$(PKGS_INSTALL) openssh
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) openssh-client openssh-server
else
	$(ERR_OS)
endif


.PHONY: tmux
tmux: $(addprefix tmux.,install dotfiles)

.PHONY: tmux.dotfiles
tmux.dotfiles: $(HOME)/.tmux.conf

$(HOME)/.tmux.conf: tmux/tmux.conf
	@$(LNS) $(realpath $<) $@

TMUX_MIN_VERSION := 3.2
.PHONY: tmux.install
tmux.install:
ifeq (void,$(DISTRO_ID))
	$(PKGS_INSTALL) 'tmux>=$(TMUX_MIN_VERSION)' 'ncurses-term>=6.3'
else ifneq (,$(filter arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) 'tmux>=$(TMUX_MIN_VERSION)'
else
	$(ERR_OS)
endif


.PHONY: waylock
waylock: $(addprefix waylock.,install dotfiles)
WAYLOCK_CONFIG_DIR := $(XDG_CONFIG_HOME)/waylock

.PHONY: waylock.dotfiles
waylock.dotfiles: $(WAYLOCK_CONFIG_DIR)/waylock.toml $(HOME)/.onsuspend

$(WAYLOCK_CONFIG_DIR)/waylock.toml: waylock/waylock.toml
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

$(HOME)/.onsuspend: waylock/onsuspend | _install.zzz-user-hooks

.PHONY: waylock.install
waylock.install:
ifeq (void,$(DISTRO_ID))
	$(PKGS_INSTALL) waylock
else
	$(ERR_OS)
endif

.PHONY: _install.zzz-user-hooks
_install.zzz-user-hooks:
ifeq (void,$(DISTRO_ID))
	$(PKGS_INSTALL) zzz-user-hooks
else
	$(ERR_OS)
endif

.PHONY: wob
wob: $(addprefix wob.,install dotfiles) service.wob

WOB_CONFIG_DIR := $(XDG_CONFIG_HOME)/wob

.PHONY: wob.dotfiles
wob.dotfiles: $(WOB_CONFIG_DIR)/conf.sh

$(WOB_CONFIG_DIR)/conf.sh: wob/conf.sh
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: wob.install
wob.install:
ifneq (,$(filter void ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) wob
else
	$(ERR_OS)
endif

.PHONY: yambar
yambar: $(addprefix yambar.,install dotfiles) service.yambar

YAMBAR_CONFIG_DIR := $(XDG_CONFIG_HOME)/yambar

.PHONY: yambar.dotfiles
yambar.dotfiles: $(YAMBAR_CONFIG_DIR)/config.yml

$(YAMBAR_CONFIG_DIR)/conf.sh: yambar/config.yml
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: yambar.install
yambar.install:
ifneq (,$(filter void,$(DISTRO_ID)))
	$(PKGS_INSTALL) yambar
else
	$(ERR_OS)
endif

.PHONY: zsh
zsh: $(addprefix zsh.,install dotfiles chsh)

.PHONY: zsh.dotfiles
ZSH_DOTFILES := $(addprefix $(HOME)/,.zprofile .zshrc)
zsh.dotfiles: $(ZSH_DOTFILES) zsh.functions zsh.plugins $(addprefix profile.,00-colors.sh 00-xdg.sh)

$(ZSH_DOTFILES): $(HOME)/.%: zsh/%
	@$(LNS) $(realpath $<) $@

ZSH_FUNCTIONS := $(addprefix $(XDG_DATA_HOME)/,$(wildcard zsh/site-functions/*))
.PHONY: zsh.functions
zsh.functions: $(ZSH_FUNCTIONS)

$(FUNCTIONS): $(XDG_DATA_HOME)/%: %
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: zsh.plugins
zsh.plugins: $(HOME)/.plugins.zsh

ZSH_PLUGINS_DIR := $(XDG_DATA_HOME)/zsh/plugins
ZSH_GIT_PLUGINS := \
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
	github.com/docker/compose

$(HOME)/.plugins.zsh: zsh/plugins.zsh | $(addprefix $(ZSH_PLUGINS_DIR)/,$(ZSH_GIT_PLUGINS)) fzf
	@$(LNS) $(realpath $<) $@

define ZSH_GIT_PLUGIN_tmpl
$$(ZSH_PLUGINS_DIR)/$(1):
ifeq (,$$(wildcard $$(ZSH_PLUGINS_DIR)/$(1)))
	$$(GIT_CLONE) https://$(1) $$@
else
	$$(GIT) -C $$@ pull -q
endif
endef
$(foreach p,$(ZSH_GIT_PLUGINS),$(eval $(call ZSH_GIT_PLUGIN_tmpl,$(p))))

.PHONY: zsh.install
zsh.install:
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) 'zsh>=5.8'
else
	$(ERR_OS)
endif

ZSH_COMMAND = $(shell command -v zsh)
.PHONY: zsh.chsh
zsh.chsh: | zsh.install zsh.add_to_shells
	[ "$$(getent passwd $(USER) | cut -d':' -f7)" = "$(ZSH_COMMAND)" ] || \
		sudo chsh -s $(ZSH_COMMAND)

.PHONY: zsh.add_to_shells
zsh.add_to_shells: /etc/shells | zsh.install
	grep -qxF $(ZSH_COMMAND) $< || echo $(ZSH_COMMAND) | sudo tee -a $< >/dev/null


.PHONY: XDG_RUNTIME_DIR
XDG_RUNTIME_DIR:
ifeq (void,$(DISTRO_ID))
	$(PKGS_INSTALL) 'dumb_runtime_dir>=1'
else
	$(ERR_OS)
endif
