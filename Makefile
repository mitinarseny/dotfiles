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
all: bin profiles services XDG_RUNTIME_DIR \
	alacritty \
	cmake \
	fd \
	firefox \
	fonts \
	foot \
	fzf \
	fzr \
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
	ripgrep \
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

PKGS_INSTALL = $(ERR_OS)
PKGS         = $(ERR_OS)
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

.PHONY: bin
BINARIES := $(notdir $(wildcard bin/*))
bin: $(addprefix bin.,$(BINARIES))

.PHONY: $(addprefix bin.,$(BINARIES))
$(addprefix bin.,$(BINARIES)): bin.%: $(HOME)/.local/bin/%

$(addprefix $(HOME)/.local/bin/,$(BINARIES)): $(HOME)/.local/bin/%: bin/%
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

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
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void ubuntu debian,$(DISTRO_ID)))
runit: PKGS := runit socklog
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
	$(CARGO_INSTALL) alacritty
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


.PHONY: fd
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
fd:
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch,$(DISTRO_ID)))
fd: PKGS := fd
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
	@$(LNS) $$(command -v fdfind) $(HOME)/.local/bin
fd: PKGS := fd-find
endif
else
fd: | rust.install
	$(CARGO_INSTALL) fd-find
endif

.PHONY: firefox
ifneq (,$(filter void arch ubuntu,$(DISTRO_ID)))
firefox: PKGS := firefox
else ifeq (debian,$(DISTRO_ID))
firefox: PKGS := firefox-esr
endif
firefox:
	$(PKGS_INSTALL) $(PKGS)

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
	awesome \
	) fonts.cache

.PHONY: _fonts.install.fontconfig
_fonts.install.fontconfig:
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
_fonts.install.fontconfig: PKGS := fontconfig
else
_fonts.install.fontconfig: PKGS = $(ERR_OS)
endif

.PHONY: fonts.cache
fonts.cache: _fonts.install.fontconfig
	fc-cache --force --verbose

.PHONY: _fonts.install.firacode
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
_fonts.install.firacode: PKGS := fonts-firacode
_fonts.install.firacode: | _install.add-apt-repository
	$(ADD_APT_REPOSITORY) $(REPO)
else
_fonts.install.firacode:
endif
	$(PKGS_INSTALL) $(PKGS)
ifeq (void,$(DISTRO_ID))
_fonts.install.firacode: PKGS := font-firacode
else ifeq (arch,$(DISTRO_ID))
_fonts.install.firacode: PKGS := ttf-fira-code
else ifeq (ubuntu,$(DISTRO_ID))
_fonts.install.firacode: REPO := universe
else ifeq (debian,$(DISTRO_ID))
_fonts.install.firacode: REPO := contrib
endif
else
FIRACODE_VERSION := 6.2
FIRACODE_ZIP := Fira_Code_v$(FIRACODE_VERSION).zip
_fonts.install.firacode:
	curl -fsSLO --output-dir /tmp https://github.com/tonsky/FiraCode/releases/download/$(FIRACODE_VERSION)/$(FIRACODE_ZIP)
	@mkdir -p $(FONTS_DIR)
	unzip -o -q -d $(FONTS_DIR) /tmp/$(FIRACODE_ZIP)
	@rm -f /tmp/$(FIRACODE_ZIP)
endif

.PHONY: _fonts.install.awesome
_fonts.install.awesome:
	$(PKGS_INSTALL) $(PKGS)
ifeq (void,$(DISTRO_ID))
_fonts.install.awesome: PKGS := font-awesome5
else ifeq (arch,$(DISTRO_ID))
_fonts.install.awesome: PKGS := ttf-font-awesome
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
_fonts.install.awesome: PKGS := fonts-font-awesome
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
fzf: fzf.install profile.00-fzf.sh

.PHONY: fzf.install
fzf.install:
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
fzf.install: PKGS := fzf
endif

.PHONY: fzr
FZRS := $(notdir $(wildcard fzr/*))
fzr: $(addprefix fzr.,$(FZRS))

FZR_CONFIG_DIR := $(XDG_CONFIG_HOME)/fzr
$(addprefix fzr.,$(FZRS)): fzr.%: $(FZR_CONFIG_DIR)/%

$(addprefix $(FZR_CONFIG_DIR)/,$(FZRS)): $(FZR_CONFIG_DIR)/%: fzr/% | bin.fzr fzf
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

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
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
git.install: PKGS := git
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
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch,$(DISTRO_ID)))
golang.install: PKGS := go
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
golang.install: PKGS := golang
endif
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
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
less.install: PKGS := less
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
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch,$(DISTRO_ID)))
mako.install: PKGS := mako
else ifeq (ubuntu,$(DISTRO_ID))
mako.install: PKGS := mako-notifier
endif

NORD_CONFIG_DIR := $(XDG_CONFIG_HOME)/nord

.PHONY: nord
nord: $(NORD_CONFIG_DIR)/colors.sh

$(NORD_CONFIG_DIR)/colors.sh: nord/colors.sh
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@


.PHONY: nvim
nvim: $(addprefix nvim.,install dotfiles) profile.10-nvim.sh lsp fd ripgrep

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
lsp: clangd gopls pyright rust_analyzer

.PHONY: gopls
gopls: | golang
	GONOPROXY=* go install golang.org/x/tools/gopls@latest

.PHONY: clangd
clangd: $(addprefix clangd.,install dotfiles)

.PHONY: clangd.dotfiles
CLANGD_CONFIG_DIR := $(XDG_CONFIG_HOME)/clangd
clangd.dotfiles: $(CLANGD_CONFIG_DIR)/config.yaml

$(CLANGD_CONFIG_DIR)/config.yaml: clangd/config.yaml
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: clangd.install
clangd.install:
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch,$(DISTRO_ID)))
clangd.install: PKGS := clang
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
clangd.install: PKGS := clangd
endif

.PHONY: pyright
pyright: | python
	pip3 install pyright

.PHONY: rust_analyzer
rust_analyzer: $(HOME)/.local/bin/rust-analyzer | profile.00-xdg.sh

$(HOME)/.local/bin/rust-analyzer:
	curl -fsSL https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-$(ARCH)-unknown-linux-$(LIBC).gz | \
		gunzip -c - > $@
	chmod +x $@


.PHONY: pipewire
pipewire: pipewire.install service.pipewire

.PHONY: pipewire.install
pipewire.install:
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
pipewire.install: PKGS := pipewire
endif


.PHONY: python
python:
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
python: PKGS := python3
endif


.PHONY: river
river: $(addprefix river.,install dotfiles) profile.99-river.sh

RIVER_CONFIG_DIR := $(XDG_CONFIG_HOME)/river

.PHONY: river.dotfiles
river.dotfiles: $(RIVER_CONFIG_DIR)/init

$(RIVER_CONFIG_DIR)/init: river/init | runit \
	alacritty \
	foot \
	fzr \
	mako \
	nord \
	pipewire \
	waylock \
	wob \
	yambar
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: river.install
river.install:
	$(PKGS_INSTALL) $(PKGS)
ifeq (void,$(DISTRO_ID))
river.install: PKGS := river xdg-desktop-portal-wlr
endif


.PHONY: ripgrep
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
ripgrep:
	$(PKGS_INSTALL) ripgrep
else
ripgrep: | rust.install
	$(CARGO_INSTALL) ripgrep
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

CARGO_INSTALL := cargo install


.PHONY: ssh
ssh: ssh.install profile.70-ssh-agent.sh

.PHONY: ssh.install
ssh.install:
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch,$(DISTRO_ID)))
ssh.install: PKGS := openssh
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
ssh.install: PKGS := openssh-client openssh-server
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
	$(PKGS_INSTALL) $(PKGS)
ifeq (void,$(DISTRO_ID))
tmux.install: PKGS := 'tmux>=$(TMUX_MIN_VERSION)' 'ncurses-term>=6.3'
else ifneq (,$(filter arch ubuntu debian,$(DISTRO_ID)))
tmux.install: PKGS := 'tmux>=$(TMUX_MIN_VERSION)'
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
	$(PKGS_INSTALL) $(PKGS)
ifeq (void,$(DISTRO_ID))
waylock.install: PKGS := waylock
endif

.PHONY: _install.zzz-user-hooks
_install.zzz-user-hooks:
	$(PKGS_INSTALL) $(PKGS)
ifeq (void,$(DISTRO_ID))
_install.zzz-user-hooks: PKGS := zzz-user-hooks
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
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void ubuntu debian,$(DISTRO_ID)))
wob.install: PKGS := wob
endif

.PHONY: yambar
yambar: $(addprefix yambar.,install dotfiles) service.yambar

YAMBAR_CONFIG_DIR := $(XDG_CONFIG_HOME)/yambar

.PHONY: yambar.dotfiles
yambar.dotfiles: $(YAMBAR_CONFIG_DIR)/config.yml

$(YAMBAR_CONFIG_DIR)/config.yml: yambar/config.yml | fonts
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: yambar.install
yambar.install:
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void,$(DISTRO_ID)))
yambar.install: PKGS := yambar
endif

.PHONY: zsh
zsh: $(addprefix zsh.,install dotfiles chsh)

export ZDOTDIR ?= $(XDG_CONFIG_HOME)/zsh

.PHONY: zsh.dotfiles
zsh.dotfiles: $(ZDOTDIR)/.zshrc zsh.functions

$(HOME)/.zprofile: zsh/zprofile | $(addprefix profile.,00-xdg.sh 10-zsh.sh)
	@$(LNS) $(realpath $<) $@

$(ZDOTDIR)/.zshrc: zsh/zshrc | $(HOME)/.zprofile zsh.plugins profile.00-colors.sh
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

ZSH_FUNCTIONS := $(addprefix $(XDG_DATA_HOME)/,$(wildcard zsh/site-functions/*))
.PHONY: zsh.functions
zsh.functions: $(ZSH_FUNCTIONS)

$(FUNCTIONS): $(XDG_DATA_HOME)/%: %
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: zsh.plugins
zsh.plugins: $(ZDOTDIR)/plugins.zsh

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

$(ZDOTDIR)/plugins.zsh: zsh/plugins.zsh | $(addprefix $(ZSH_PLUGINS_DIR)/,$(ZSH_GIT_PLUGINS)) \
	fzf \
	@mkdir -p $(dir $@)
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
	$(PKGS_INSTALL) $(PKGS)
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
zsh.install: PKGS := 'zsh>=5.8'
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
	$(PKGS_INSTALL) $(PKGS)
ifeq (void,$(DISTRO_ID))
XDG_RUNTIME_DIR: PKGS := 'dumb_runtime_dir>=1'
endif
