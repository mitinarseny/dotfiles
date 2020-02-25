SUBS := $(wildcard */Makefile)

ifeq ($(shell uname -s),Darwin)
SUBS += $(wildcard */Makefile.macos)
endif

.PHONY: all
all: $(SUBS)

.PHONY: $(SUBS)
$(SUBS):
	$(info > $@)
	@$(MAKE) -C $(@D) -f $(@F)

