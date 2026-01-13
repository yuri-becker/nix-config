{
  config,
  lib,
  pkgs,
  wakatime-ls,
  ...
}:
let
  wakatime-ls-pkg = wakatime-ls.packages.${pkgs.system}.wakatime-ls;
in
{
  config = lib.mkIf config.localhost.enable {
    home.packages = [
      pkgs.wakatime-cli
      # wakatime-ls-pkg # until https://github.com/wakatime/zed-wakatime/issues/99 is fixed
    ];
    sops.secrets."wakatime/api_key".sopsFile = ./wakatime.secrets.yaml;
    home.file.".wakatime.cfg" = {
      enable = true;
      text = lib.generators.toINI { } {
        settings = {
          api_url = "https://wakapi.catboy.house/api";
          api_key_vault_cmd = "cat ${config.sops.secrets."wakatime/api_key".path}";
          status_bar_enabled = true;
        };
      };
    };
    programs.helix.languages.language-server.wakatime = {
      command = "${lib.getExe wakatime-ls-pkg}";
    };
  };
}
