FILES != ls | grep -v Makefile | grep -v ~

.PHONY: install
install:
	@echo Symlinking files in bin...
	@mkdir -p $$HOME/bin
	@for FILE in ${FILES}; do \
	    ln -vsf ${.CURDIR}/$$FILE $$HOME/bin/$$FILE; \
	done
