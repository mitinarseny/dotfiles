UNAME         := $(shell uname -s)
DOTFILES_ROOT := $(realpath $(CURDIR)/..)

FIRA_CODE_FONTS := \
	Bold \
	Light \
	Medium \
	Regular \
	Retina
FIRA_CODE_FONT_FILES = $(patsubst %,$(INSTALL_DIR)/FiraCode-%.ttf,$(FIRA_CODE_FONTS))

FONT_FILES = $(FIRA_CODE_FONT_FILES)

.PHONY: install
ifeq (Darwin,$(UNAME))
INSTALL_DIR := $(HOME)/Library/Fonts
install: | font-files .fc-cache
else
INSTALL_DIR := $(HOME)/.fonts
install: | font-files
endif
	fc-cache --force --verbose $(INSTALL_DIR)

.PHONY: font-files
font-files: $(FONT_FILES)

$(FONT_FILES): $(INSTALL_DIR)/FiraCode-%.ttf: | $(INSTALL_DIR)
	curl --silent --location --output $@ \
	  "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-$*.ttf?raw=true"

$(INSTALL_DIR):
	@mkdir -p $@

ifeq (Darwin, $(UNAME))
include ../macos/brew.mk
endif

.PHONY: .fc-cache
ifeq (Darwin,$(UNAME))
.fc-cache: | brew
ifeq (,$(shell brew list --versions fontconfig))
	brew install fontconfig
endif
endif

.PHONY: clean
clean:
	$(RM) $(FONT_FILES)
