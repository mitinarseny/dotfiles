include ../inc.mk

.PHONY: all
all: install

VERSION ?= 3.32.0
GITHUB_RELEASE := https://github.com/Kitware/CMake/releases/download/v$(VERSION)

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += cmake
else
install:
ifeq (linux,$(KERNEL))
	curl -fsSL $(GITHUB_RELEASE)/cmake-$(VERSION)-linux-$(ARCH).tar.gz | \
		sudo tar -xzv --strip 1 -C /usr/local
else ifeq (darwin,$(KERNEL))
	curl -fsSL $(GITHUB_RELEASE)/cmake-$(VERSION)-macos-universal.tar.gz | \
		sudo tar -xzv --strip 1 -C /usr/local
else
	$(ERR_KERNEL)
endif
endif
