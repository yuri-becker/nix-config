{ config, lib, ... }:
let
  sopsFile = ./pocket-id.secrets.yaml;
  database = {
    name = "pocket-id";
    password = "pocket-id";
  };
in
{
  options.pocket-id.domain =
    with lib;
    mkOption {
      type = lib.types.str;
      default = "id.home.arpa";
    };
  config = {
    sops.secrets = {
      "pocket-id/encryption_key" = {
        sopsFile = sopsFile;
        owner = config.services.pocket-id.user;
        group = config.services.pocket-id.group;
      };
      "pocket-id/maxmind_api_key" = {
        sopsFile = sopsFile;
        owner = config.services.pocket-id.user;
        group = config.services.pocket-id.group;
      };
    };

    services.postgresql = {
      ensureDatabases = [ database.name ];
      ensureUsers = [
        {
          name = "${config.services.pocket-id.user}";
          ensureDBOwnership = true;
        }
      ];
    };

    services.pocket-id = {
      enable = true;
      user = database.name;
      settings = {
        APP_URL = "https://${config.pocket-id.domain}";
        ANALYTICS_DISABLED = true;
        TRUST_PROXY = true;
        ENCRYPTION_KEY_FILE = config.sops.secrets."pocket-id/encryption_key".path;
        MAXMIND_LICENSE_KEY_FILE = config.sops.secrets."pocket-id/maxmind_api_key".path;
        DB_PROVIDER = "postgres";
        DB_CONNECTION_STRING = "postgres://${database.name}?host=/run/postgresql";
        KEYS_STORAGE = "database";
        PORT = 1411;
      };
    };

    services.borgmatic.configurations.mantis.source_directories = [
      config.services.pocket-id.dataDir
    ];

    services.caddy.virtualHosts."${config.pocket-id.domain}".extraConfig =
      "reverse_proxy :${toString config.services.pocket-id.settings.PORT}";
  };
}
