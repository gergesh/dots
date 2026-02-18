{ ... }: {
  networking.hostName = "money";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = 6;
}
