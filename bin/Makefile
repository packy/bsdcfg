srcdir := $(shell pwd)
files  := $(filter-out Makefile $(wildcard *~), $(wildcard *))

.PHONY: install
install: $(dotfiles)
	@echo Symlinking files in bin...
	@for FILE in $(files); do \
	    ln -vsf $(srcdir)/$$FILE $(HOME)/bin/$$FILE; \
	done
