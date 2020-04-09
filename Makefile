SUBS := \
  alacritty \
  antibody \
  bat \
  dircolors \
  editorconfig \
  fd \
  fonts \
  fzf \
  git \
  inputrc \
  nvim \
  ripgrep \
  tmux \
  zsh

ifeq (Darwin,$(shell uname -s))
SUBS += \
	brew \
	macos
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
