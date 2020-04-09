DOTFILES := ~/.editorconfig

.PHONY: dotfiles
dotfiles: $(DOTFILES)

~/.editorconfig: editorconfig
	@ln -svf $(realpath $<) $@

.PHONY: clean
clean:
	$(RM) $(DOTFILES)
