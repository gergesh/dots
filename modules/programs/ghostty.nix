{ ... }: {
  xdg.configFile."ghostty/config".text = ''
    command = /bin/zsh -i -c /opt/homebrew/bin/tmux new -A -s main
    font-size = 20
    macos-option-as-alt = true
    auto-update-channel = tip
  '';
}
