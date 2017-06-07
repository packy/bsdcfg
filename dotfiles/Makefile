DOTFILES != ls | grep -v Makefile | grep -v ~

.PHONY: install
install:
	@echo Symlinking dotfiles...
	@for FILE in ${DOTFILES}; do \
	    ln -vsf ${.CURDIR}/$$FILE $$HOME/.$$FILE; \
	done
