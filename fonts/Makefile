UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
INSTALL_DIR := ~/Library/Fonts
else
INSTALL_DIR := ~/.fonts
endif

.PHONY: fira_code
fira_code: $(INSTALL_DIR) \
	$(patsubst %,$(INSTALL_DIR)/FiraCode-%.ttf,\
	Bold \
	Light \
	Medium \
	Regular \
	Retina \
	)
ifneq ($(UNAME),Darwin)
	fc-cache --force --verbose $(INSTALL_DIR)
endif

$(INSTALL_DIR):
	mkdir -p $@

$(INSTALL_DIR)/FiraCode-%.ttf:
	wget -O $@ "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-$*.ttf?raw=true"

