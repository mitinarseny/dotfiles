~/.zsh_plugins.sh: bundles.txt
ifeq (,$(shell command -v antibody 2>&1))
	curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
endif
	antibody bundle < $< > $@
ifeq (Darwin,$(shell uname -s))
	antibody bundle Homebrew/brew kind:fpath path:completions/zsh >> $@
endif
