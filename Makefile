include inc.mk

.PHONY: all
all: $(addprefix make_,$(ROOT_SUBDIRS))

.PHONY: install
install: | zsh chsh_to_zsh river

ZSH_COMMAND = $(shell command -v zsh)

.PHONY: chsh_to_zsh
chsh_to_zsh: | zsh add_zsh_to_shells
	[ "$$(getent passwd $(USER) | cut -d':' -f7)" = "$(ZSH_COMMAND)" ] || \
		sudo chsh -s $(ZSH_COMMAND)

.PHONY: add_zsh_to_shells
add_zsh_to_shells: /etc/shells | zsh
	grep -qxF $(ZSH_COMMAND) $< || echo $(ZSH_COMMAND) | sudo tee -a $< >/dev/null
