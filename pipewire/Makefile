include ../inc.mk

.PHONY: all
all: install services

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += pipewire
else
install: ; $(ERR_OS)
endif
