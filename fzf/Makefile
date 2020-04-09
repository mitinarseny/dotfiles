FZF_DIR := ~/.fzf

.PHONY: install
install: | $(FZF_DIR)
	$(FZF_DIR)/install --bin

$(FZF_DIR):
	git clone --depth 1 "https://github.com/junegunn/fzf.git" $@

.PHONY: uninstall
uninstall:
	$(RM) -r $(FZF_DIR)

