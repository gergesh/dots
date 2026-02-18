{ config, pkgs, lib, ... }: {
  imports = [
    ./shell/zsh.nix
    ./shell/aliases.nix
    ./shell/environment.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/git.nix
    ./programs/readline.nix
    ./programs/fzf.nix
    ./programs/ghostty.nix
    ./programs/helix.nix
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    trash-cli
    fasd
  ];

  # ptpython config
  xdg.configFile."ptpython/config.py".source = ../files/ptpython.py;

  # Install usercustomize.py to the Python site-packages directory
  home.activation.installUsercustomize =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      site_dir="$(${pkgs.python3}/bin/python3 -s -m site --user-site)"
      mkdir -p "$site_dir"
      cp ${../files/usercustomize.py} "$site_dir/usercustomize.py"
    '';

  # Scripts -> ~/.local/bin/
  home.file.".local/bin/apk-pull" = { source = ../scripts/apk-pull; executable = true; };
  home.file.".local/bin/cmus" = { source = ../scripts/cmus; executable = true; };
  home.file.".local/bin/lyrics" = { source = ../scripts/lyrics; executable = true; };
  home.file.".local/bin/lyrics-edit" = { source = ../scripts/lyrics-edit; executable = true; };
  home.file.".local/bin/tmux-run-fg" = { source = ../scripts/tmux-run-fg; executable = true; };

  # Scripts -> ~/.local/lib/
  home.file.".local/lib/cmusync.sh" = { source = ../scripts/cmusync.sh; executable = true; };
  home.file.".local/lib/p_wrapper.py" = { source = ../scripts/p_wrapper.py; executable = true; };
}
