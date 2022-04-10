include ../inc.mk

.PHONY: dotfiles
dotfiles: $(HOME)/.inputrc

$(HOME)/.inputrc: inputrc
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@
