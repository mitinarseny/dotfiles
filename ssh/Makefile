include ../inc.mk

.PHONY: all
all: install profiles

.PHONY: install
ifneq (,$(filter void arch,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += openssh
else ifneq (,$(filter ubuntu debian,$(DISTRO_ID))))
install: | install_pkgs
install_pkgs: PKGS += openssh-client openssh-server
else
instal: ; $(ERR_OS)
endif
