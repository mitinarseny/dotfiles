SUBS := \
  alacritty \
  antibody \
  bat \
  dircolors \
  editorconfig \
  fonts \
  fzf \
  git \
  inputrc \
  nvim \
  tmux \
  zsh

ifeq (Darwin,$(shell uname -s))
SUBS += macos
endif

.PHONY: all
all: $(SUBS)

.PHONY: $(SUBS)
$(SUBS):
	$(info > $@)
	-@$(MAKE) -C $@

.PHONY: update
update: pull $(SUBS)

.PHONY: pull
pull:
	git pull origion
