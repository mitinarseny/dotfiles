ifeq ($(shell uname -s),Darwin)
INSTALL_DIR := ~/Library/Fonts
else
INSTALL_DIR := ~/.fonts
endif

.PHONY: fira_code
fira_code: $(patsubst %,$(INSTALL_DIR)/FiraCode-%.ttf,\
	Bold \
	Light \
	Medium \
	Regular \
	Retina \
	)
ifneq ($(UNAME),Darwin)
	fc-cache --force --verbose --error-on-no-fonts $(INSTALL_DIR)
endif

$(INSTALL_DIR):
	@mkdir -p $@

$(INSTALL_DIR)/FiraCode-%.ttf: | $(INSTALL_DIR)
	curl --silent --location --output $@ \
	  "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-$*.ttf?raw=true"

