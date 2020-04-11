UNAME := $(shell uname -s)

SUBDIRS := $(dir $(wildcard */Makefile))

MACOS_SPECIFIC := macos

ifeq (Darwin,$(UNAME))
SUBDIRS := $(filter-out $(addsuffix /,$(MACOS_SPECIFIC)),$(SUBDIRS))
endif

.PHONY: all
all: $(SUBDIRS)

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	@$(MAKE) --print-directory --directory $@ $(MAKECMDGOALS)

.PHONY: update
update: pull all

.PHONY: pull
pull:
	git pull origin

.PHONY: test
test: $(SUBDIRS)

