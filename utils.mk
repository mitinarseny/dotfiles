DOTFILES_ROOT := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

UNAME := $(shell uname -s)
ifeq (Darwin,$(UNAME))
include $(DOTFILES_ROOT)/macos/brew.mk
endif
