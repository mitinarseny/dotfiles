.PHONY: all
all: \
	zsh \
	antibody \
	tmux \
	nvim \
	git \
	fzf \
	bat \
	fonts \
	editorconfig \
	vscode

.PHONY: zsh
zsh:
	$(MAKE) -C zsh

.PHONY: antibody
antibody:
	$(MAKE) -C antibody

.PHONY: tmux
tmux:
	$(MAKE) -C tmux

.PHONY: nvim
nvim:
	$(MAKE) -C nvim

.PHONY: git
git:
	$(MAKE) -C git

.PHONY: fzf
fzf:
	$(MAKE) -C fzf

.PHONY: bat
bat:
	$(MAKE) -C bat

.PHONY: fonts
fonts:
	$(MAKE) -C fonts

.PHONY: editorconfig
editorconfig:
	$(MAKE) -C editorconfig

ifeq ($(shell uname -s),Darwin)
all: macos
.PHONY: macos
macos:
	$(MAKE) -C macos
endif
