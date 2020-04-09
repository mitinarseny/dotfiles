UNAME := $(shell uname -s)

SUBS := $(dir $(wildcard */Makefile))

MACOS_SPECIFIC := macos

ifeq (Darwin,$(UNAME))
SUBS := $(filter-out $(addsuffix /,$(MACOS_SPECIFIC)),$(SUBS))
endif

.PHONY: all
all: $(SUBS)

.PHONY: $(SUBS)
$(SUBS):
	$(info --> make $@)
	-@$(MAKE) -C $@

.PHONY: update
update: pull $(SUBS)

.PHONY: pull
pull:
	git pull origin
