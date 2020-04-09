DOTFILES := ~/.inputrc

.PHONY: dotfiles
dotfiles: $(DOTFILES)

~/.inputrc: inputrc
	@ln -svf $(realpath $<) $@

.PHONY: clean
clean:
	$(RM) $(DOTFILES)
