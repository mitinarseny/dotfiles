SUBS := $(dir $(wildcard */Makefile))

.PHONY: all
all: $(SUBS)

.PHONY: $(SUBS)
$(SUBS):
	$(info make: $@)
	@$(MAKE) -C $@

