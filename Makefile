install: nvim nvim-plug tmux tpm bins libs zsh ptpython
install-offline: nvim nvim-plug-offline tmux tpm-offline bins libs zsh ptpython

nvim:
	mkdir -p ~/.config/nvim
	cp vimrc ~/.config/nvim/init.vim

nvim-plug:
	[ -f ~/.local/share/nvim/site/autoload/plug.vim ] || \
		curl -L https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
		     -o ~/.local/share/nvim/site/autoload/plug.vim \
		     --create-dirs

nvim-plug-offline:
	mkdir -p  ~/.local/share/nvim/site/autoload/
	cp ./offline-preparation/vim-plugins/vim-plug/plug.vim ~/.local/share/nvim/site/autoload/

tmux:
	mkdir -p ~/.config/tmux
	cp tmux.conf ~/.config/tmux/tmux.conf
	[ -L ~/.tmux.conf ] || ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf

tpm:
	[ -d ~/.config/tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
	~/.config/tmux/plugins/tpm/scripts/install_plugins.sh

tpm-offline:
	mkdir -p ~/.config/tmux/plugins
	cp -r ./offline-preparation/tmux-plugins/tpm ~/.config/tmux/plugins/
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

prepare-offline:
	mkdir -p offline-preparation \
		; cd offline-preparation \
		; mkdir -p vim-plugins \
		; cd vim-plugins \
			; git clone https://github.com/junegunn/vim-plug --depth=1 \
			; cat ../../vimrc \
			| grep -Po "Plug '\K([^/]+/[^']+)" \
			| sed 's/^/https:\/\/github.com\//' \
			| xargs -I {} git clone --depth=1 {}
	cd offline-preparation \
		; mkdir -p tmux-plugins \
		; cd tmux-plugins \
			; cat ../../tmux.conf \
			| grep -Po "set-option -g @plugin '\K[^']+" \
			| sed 's/^/https:\/\/github.com\//' \
			| xargs -I {} git clone --depth=1 {}
	cd offline-preparation \
		; mkdir -p python-packages \
		; cd python-packages \
			; pip download ptpython
	cd offline-preparation \
		; mkdir -p util \
		; cd util \
			; git clone https://github.com/clvv/fasd --depth=1 \
