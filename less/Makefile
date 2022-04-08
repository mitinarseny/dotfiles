include ../inc.mk

.PHONY: all
all: install profiles

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += less
else
install: ; $(ERR_OS)
endif
