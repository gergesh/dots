install: nvim nvim-plug tmux tpm bins libs zsh

nvim:
	mkdir -p ~/.config/nvim
	cp vimrc ~/.config/nvim/init.vim

nvim-plug:
	mkdir -p ~/.local/share/nvim/site/autoload
	curl -L https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o ~/.local/share/nvim/site/autoload/plug.vim

tmux:
	mkdir -p ~/.config/tmux
	cp tmux.conf ~/.config/tmux/tmux.conf

tpm:
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm || true
	~/.config/tmux/plugins/tpm/scripts/install_plugins.sh

bins:
	mkdir -p ~/.local/bin
	cp bin/* ~/.local/bin/

libs:
	mkdir -p ~/.local/lib
	cp lib/* ~/.local/lib/

zsh:
	mkdir -p ~/.config
	cp zshrc ~/.zshrc
	cp aliasrc ~/.config/
	cp exportrc ~/.config/
