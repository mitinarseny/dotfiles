

~/.zsh_plugins.sh: bundles.txt
ifeq (,$(shell command -v antibody > /dev/null 2>&1))
	curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
endif
	antibody bundle < $< > $@
