FZF_DIR := ~/.fzf

.PHONY: install
install: | $(FZF_DIR)
	$(FZF_DIR)/install --bin

$(FZF_DIR):
	git clone --depth 1 "https://github.com/junegunn/fzf.git" $@

.PHONY: update
update: | pull install

.PHONY: pull
pull:
	git -C $(FZF_DIR) pull

.PHONY: uninstall
uninstall:
	$(RM) -r $(FZF_DIR)

