install: nvim nvim-plug tmux tpm bins libs zsh ptpython

nvim:
	mkdir -p ~/.config/nvim
	cp vimrc ~/.config/nvim/init.vim

nvim-plug:
	[ -f ~/.local/share/nvim/site/autoload/plug.vim ] || \
		curl -L https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
		     -o ~/.local/share/nvim/site/autoload/plug.vim \
		     --create-dirs

tmux:
	mkdir -p ~/.config/tmux
	cp tmux.conf ~/.config/tmux/tmux.conf
	[ -L ~/.tmux.conf ] || ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf

tpm:
	[ -d ~/.config/tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
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

ptpython:
	mkdir -p ~/.config/ptpython
	cp ptpython.py ~/.config/ptpython/config.py
