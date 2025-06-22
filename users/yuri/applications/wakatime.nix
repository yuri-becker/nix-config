{ config, lib, ... }:{
  sops.secrets."wakatime/api_key" = { sopsFile = ./wakatime.secrets.yaml; };
  home.file.".wakatime.cfg" = {
    enable = true;
    text = lib.generators.toINI { } {
      settings = {
        api_url = "https://wakapi.catboy.house/api";
        api_key_vault_cmd =
          "cat ${config.sops.secrets."wakatime/api_key".path}";
        status_bar_enabled = true;
      };
    };
  };
}
