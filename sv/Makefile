include ../inc.mk

.PHONY: all
all: install

.PHONY: install
ifneq (,$(filter void ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += runit socklog
else
install: ; $(ERR_OS)
endif
