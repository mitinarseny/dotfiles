include ../inc.mk

.PHONY: all
all: install profiles

.PHONY: install
install:
ifeq (,$(shell command -v rustup))
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
		sh -s -- -y --no-modify-path
else
	rustup self update
endif
