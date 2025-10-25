{ config, lib, ... }:
let
  domain = "photos.home.arpa";
  sopsFile = ./immich.secrets.yaml;
in
{
  sops.secrets."immich/smtp/from".sopsFile = sopsFile;
  sops.secrets."immich/smtp/username".sopsFile = sopsFile;
  sops.secrets."immich/smtp/password".sopsFile = sopsFile;
  sops.secrets."immich/external-domain".sopsFile = sopsFile;
  sops.secrets."immich/oauth/id".sopsFile = sopsFile;
  sops.secrets."immich/oauth/secret".sopsFile = sopsFile;
  sops.templates."immich.json" = {
    owner = config.services.immich.user;
    content = lib.generators.toJSON { } {
      notifications.smtp = {
        enabled = true;
        transport.host = "mail.smtp2go.com";
        transport.port = 2525;
        transport.ignoreCert = false;
        from = config.sops.placeholder."immich/smtp/from";
        replyTo = config.sops.placeholder."immich/smtp/from";
        transport.username = config.sops.placeholder."immich/smtp/username";
        transport.password = config.sops.placeholder."immich/smtp/password";
      };
      server.externalDomain = config.sops.placeholder."immich/external-domain";
      server.publicUsers = false;
      storageTemplate.enabled = false;
      trash = {
        enabled = true;
        days = 360;
      };
      reverseGeocoding.enabled = true;
      passwordLogin.enabled = false;
      newVersionCheck.enabled = false;
      backup.database.enabled = false; # Is backed up via Borgmatic
      oauth = {
        enabled = true;
        autoLaunch = false;
        autoRegister = true;
        buttonText = "Login with Pocket ID";
        clientId = config.sops.placeholder."immich/oauth/id";
        clientSecret = config.sops.placeholder."immich/oauth/secret";
        issuerUrl = "https://id.home.arpa";
      };
    };
  };
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 30002;
    environment.IMMICH_CONFIG_FILE = config.sops.templates."immich.json".path;
  };
  services.caddy.virtualHosts."${domain}".extraConfig =
    "reverse_proxy :${toString config.services.immich.port}";
  services.borgmatic.configurations.mantis.source_directories = [
    config.services.immich.mediaLocation
  ];
  homer.links = [
    {
      name = "Immich";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/immich.png";
      url = "https://photos.home.arpa";
    }
  ];
}
