include ../inc.mk

.PHONY: all
all: install include_files set_user set_credential_helper

.PHONY: include_files
include_files: include_config_local include_excludes

GIT_CONFIG_GLOBAL := git config --global

.PHONY: include_config_local
include_config_local: config.local
ifeq (,$(shell $(GIT_CONFIG_GLOBAL) --get include.path "$(realpath config.local)"))
	$(GIT_CONFIG_GLOBAL) --add include.path "$(realpath $<)"
endif

.PHONY: include_excludes
include_excludes: excludes
ifeq (,$(shell $(GIT_CONFIG_GLOBAL) --get core.excludesfile "$(realpath excludes)"))
	$(GIT_CONFIG_GLOBAL) --add core.excludesfile "$(realpath $<)"
endif

ifneq (,$(filter linux darwin,$(KERNEL)))
CREDENTIAL_HELPER := cache
ifeq (darwin,$(KERNEL))
CREDENTIAL_HELPER := osxkeychain
endif
.PHONY: set_credential_helper
set_credential_helper:
ifeq (,$(shell $(GIT_CONFIG_GLOBAL) --get credential.helper))
	$(GIT_CONFIG_GLOBAL) credential.helper $(CREDENTIAL_HELPER)
endif
endif

define SET_USER_tmpl
.PHONY: set_user_$(1)
set_user_$(1):
ifeq (,$(shell $(GIT_CONFIG_GLOBAL) --get user.$(1)))
	read -r -p 'GitHub user $(1): ' user_$(1) && $(GIT_CONFIG_GLOBAL) user.$(1) "$${user_$(1)}"
endif
endef
$(foreach key,email name,$(eval $(call SET_USER_tmpl,$(key))))

.PHONY: set_user
set_user: $(addprefix set_user_,email name)

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += git
else
install: ; $(ERR_OS)
endif
