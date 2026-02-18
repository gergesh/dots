{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      nord-vim
      vim-tmux-navigator
      fzf-vim
      vim-sandwich
      coc-nvim
      delimitMate
      vim-hexedit
      vim-sleuth
      vim-airline
      vim-airline-themes
      vimoutliner
    ];

    extraPackages = with pkgs; [
      fzf
      nodejs
    ];

    extraConfig = builtins.readFile ../../files/vimrc;
  };
}
