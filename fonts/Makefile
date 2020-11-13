include ../utils.mk
.DEFAULT_GOAL :=

FIRA_CODE_FONTS := \
	Bold \
	Light \
	Medium \
	Regular \
	Retina

ifeq (Darwin,$(UNAME))
INSTALL_DIR := $(HOME)/Library/Fonts
else
INSTALL_DIR := $(HOME)/.fonts
endif

FIRA_CODE_FONT_FILES := $(patsubst %,$(INSTALL_DIR)/FiraCode-%.ttf,$(FIRA_CODE_FONTS))

FONT_FILES := $(FIRA_CODE_FONT_FILES)

.PHONY: font-files
font-files: $(FONT_FILES)

$(FIRA_CODE_FONT_FILES): $(INSTALL_DIR)/FiraCode-%.ttf: | $(INSTALL_DIR)
	curl --silent --location --output $@ \
	  "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-$*.ttf?raw=true"

$(INSTALL_DIR):
	@mkdir -p $@

.PHONY: install
ifeq (Darwin,$(UNAME))
install: | font-files .fc-cache
else
install: | font-files
endif
	fc-cache --force --verbose $(INSTALL_DIR)

.PHONY: .fc-cache
ifeq (Darwin,$(UNAME))
.fc-cache: | brew
	brew install fontconfig
endif

.PHONY: clean
clean:
	$(RM) $(FONT_FILES)
