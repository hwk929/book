link:
	@echo "Setting symlinks"
	@stow src

unlink:
	@echo "Removing symlinks"
	@stow -D src

relink:
	@echo "Resetting symlinks"
	@stow -D src
	@stow src

list:
	@tree -a -I ".git|plugins"
