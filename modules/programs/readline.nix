{ ... }: {
  programs.readline = {
    enable = true;
    includeSystemConfig = true;
    extraConfig = ''
      "\e[A": history-search-backward
      "\e[B": history-search-forward
    '';
  };
}
