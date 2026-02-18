{ ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = ''rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!.jj/*"'';
  };
}
