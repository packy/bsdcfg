all: install

.PHONY: install
install:
	@cd dotfiles && $(MAKE)
	@cd bin      && $(MAKE)
	@ln -sf $$HOME/.bashrc.d $$HOME/git/bsdcfg/.bashrc.d
