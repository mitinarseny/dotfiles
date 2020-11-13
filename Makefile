include utils.mk

SUBDIRS := \
	alacritty \
	bat \
	editorconfig \
	fonts \
	git \
	inputrc \
	less \
	nvim \
	python \
	tmux \
	zsh

ifeq (Darwin,$(UNAME))
SUBDIRS += macos
endif

.PHONY: all
all: $(SUBDIRS)

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	@$(MAKE) --print-directory --directory $@

.PHONY: update
update: pull all

.PHONY: pull
pull:
	git pull origin
