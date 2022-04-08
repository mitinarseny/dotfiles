include ../inc.mk

VERSION ?= 1.18

.PHONY: all
all: install profiles

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
ifneq (,$(filter void arch,$(DISTRO_ID)))
install_pkgs: PKGS += go
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID)))
install_pkgs: PKGS += golang
endif
else
ifeq (x86_64,$(ARCH))
install: GOARCH := amd64
else ifeq (x86,$(ARCH))
install: GOARCH := 386
else ifeq (aarch64,$(ARCH)))
install: GOARCH := arm64
else
install: GOARCH := $(error Unsupported arch: "$(ARCH)")
endif
install:
	-@sudo rm -rf /usr/local/go
	curl -fsSL https://go.dev/dl/go$(VERSION).$(KERNEL)-$(GOARCH).tar.gz | \
		sudo tar -xzv -C /usr/local
endif
