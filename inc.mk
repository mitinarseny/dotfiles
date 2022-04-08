REQUIRED_FEATURES := else-if target-specific order-only undefine
ifneq ($(words $(REQUIRED_FEATURES)),$(words $(filter $(REQUIRED_FEATURES),$(.FEATURES))))
$(error Current make version does not support required features: $(REQUIRED_FEATURES))
endif
undefine REQUIRED_FEATURES

export UID ?= $(shell id -u)

export XDG_CONFIG_HOME ?= $(HOME)/.config
export XDG_CACHE_HOME ?= $(HOME)/.cache
export XDG_DATA_HOME ?= $(HOME)/.local/share
export XDG_STATE_HOME ?= $(HOME)/.local/state
export XDG_RUNTIME_DIR ?= /run/user/$(UID)

LNS := ln -sfv
GIT := git
GIT_CLONE = $(GIT) clone -q

KERNEL := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH   := $(shell uname -m)
ifneq (,$(filter i386,$(ARCH)))
ARCH   := x86
else ifeq (aarch64_be,$(ARCH))
ARCH   := aarch64
endif
LIBC := gnu
ifneq (,$(shell ldd --version 2>&1 | grep musl))
LIBC := musl
endif

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

# Package managers
ERR_OS = $(error Unsupported OS: "$(DISTRO_ID)")

.PHONY: install_pkgs
install_pkgs:
ifeq (void,$(DISTRO_ID))
	sudo xbps-install -Su --yes $(PKGS)
else ifeq (arch,$(DISTRO_ID))
	sudo pacman -Sy --noconfirm $(PKGS)
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
	sudo apt-get update && sudo apt-get install --yes $(PKGS)
else
	$(ERR_OS)
endif

DOTFILES_ROOT := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
ROOT_SUBDIRS  := $(patsubst $(DOTFILES_ROOT)/%/,%,$(dir $(wildcard $(DOTFILES_ROOT)/*/Makefile)))
.PHONY: $(addprefix make_,$(ROOT_SUBDIRS))
$(addprefix make_,$(ROOT_SUBDIRS)): make_%:
	@$(MAKE) -C $(DOTFILES_ROOT)/$*

ifndef NOPROFILES
PROFILE_DIR    := $(HOME)/.profile.d
PROFILE_SRCDIR ?= profile.d
# Profiles are [0-9][0-9]-*.sh files found in $(PROFILE_SRCDIR)/.
# First two digits denote the order when to source these files.
PROFILES := $(addprefix $(PROFILE_DIR)/,$(notdir $(wildcard $(PROFILE_SRCDIR)/[0-9][0-9]-*.sh)))
.PHONY: profiles
profiles: $(PROFILES)

$(PROFILES): $(PROFILE_DIR)/%: $(PROFILE_SRCDIR)/%
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@
endif

ifndef NOSERVICES
SVDIR := $(HOME)/.local/sv
SVSRCDIR ?= sv

SV_FILES := $(patsubst $(SVSRCDIR)/%,$(SVDIR)/%,\
	$(wildcard $(addprefix $(SVSRCDIR)/*/,run finish check down log/run log/finish)))
.PHONY: services
services: $(SV_FILES)
$(filter-out %/run,$(SV_FILES)): $(SVDIR)/%: $(SVSRCDIR)/%
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

$(SVDIR)/%/run: $(SVSRCDIR)/%/run | $(SVDIR)/%/supervise
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PRECIOUS: $(SVDIR)/%/supervise
$(SVDIR)/%/supervise:
	@mkdir -p $(dir $@)
	@$(LNS) $(XDG_RUNTIME_DIR)/supervise.$(notdir $*) $@
	
.PRECIOUS: $(SVDIR)/%/log/supervise
$(SVDIR)/%/log/supervise:
	@mkdir -p $(dir $@)
	@$(LNS) $(XDG_RUNTIME_DIR)/supervise.$(notdir $*)-log $@
endif

.DEFAULT_GOAL :=
