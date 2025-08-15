{
  pkgs,
  lib,
  specialArgs,
  config,
  ...
}:
{
  home.packages = lib.mkIf (!pkgs.stdenv.isDarwin) [ pkgs.bitwarden-cli ];

  sops.secrets."bitwarden/bw_session" = {
    sopsFile = ./bitwarden.${specialArgs.hostname}.secrets.yaml;
  };
  sops.templates."bw-login.fish".content = ''
    set --export --global BW_SESSION ${config.sops.placeholder."bitwarden/bw_session"}
  '';

  programs.fish.functions.bw-login = "source ${config.sops.templates."bw-login.fish".path}";
}
