include inc.mk

.PHONY: all
all: $(addprefix make_,$(ROOT_SUBDIRS))

