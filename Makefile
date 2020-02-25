SUBS := $(dir $(wildcard */Makefile))

ifeq ($(shell uname -s),Darwin)
SUBS += macos
endif

.PHONY: all
all: $(SUBS)

.PHONY: $(SUBS)
$(SUBS):
	$(info > $@)
	@$(MAKE) -C $@

