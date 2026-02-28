{ config, lib, ... }:
let
  sopsFile = ./paperless.secrets.yaml;
  domain = "documents.home.arpa";
in
{
  sops.secrets = {
    "paperless/secret".sopsFile = sopsFile;
    "paperless/pocket_id/client_id".sopsFile = sopsFile;
    "paperless/pocket_id/client_secret".sopsFile = sopsFile;
    "paperless/email/host".sopsFile = sopsFile;
    "paperless/email/port".sopsFile = sopsFile;
    "paperless/email/user".sopsFile = sopsFile;
    "paperless/email/password".sopsFile = sopsFile;
  };
  sops.templates."paperless.env" = {
    owner = config.services.paperless.user;
    content =
      let
        secrets = config.sops.placeholder;
      in
      lib.generators.toKeyValue { } {
        PAPERLESS_SECRET_KEY = secrets."paperless/secret";
        PAPERLESS_SOCIALACCOUNT_PROVIDERS = builtins.toJSON {
          openid_connect = {
            SCOPE = [
              "openid"
              "profile"
              "email"
            ];
            OAUTH_PKCE_ENABLED = true;
            APPS = [
              {
                provider_id = "authelia"; # For compatibility with existing database
                name = "Pocket ID";
                client_id = secrets."paperless/pocket_id/client_id";
                secret = secrets."paperless/pocket_id/client_secret";
                settings.server_url = "https://${config.pocket-id.domain}";
              }
            ];
          };
        };
        PAPERLESS_EMAIL_HOST = secrets."paperless/email/host";
        PAPERLESS_EMAIL_PORT = secrets."paperless/email/port";
        PAPERLESS_EMAIL_HOST_USER = secrets."paperless/email/user";
        PAPERLESS_EMAIL_HOST_PASSWORD = secrets."paperless/email/password";
        REQUESTS_CA_BUNDLE = import ./cert.nix;
      };
  };
  services.paperless = {
    enable = true;
    inherit domain;
    environmentFile = config.sops.templates."paperless.env".path;
    configureTika = true;
    database.createLocally = true;
    consumptionDirIsPublic = true;
    settings = {
      PAPERLESS_OCR_LANGUAGES = "eng deu dan";
      PAPERLESS_OCR_LANGUAGE = "deu";
      PAPERLESS_OCR_USER_ARGS = builtins.toJSON { continue_on_soft_render_error = true; };
      PAPERLESS_CONSUMER_ENABLE_BARCODES = true;
      PAPERLESS_EMAIL_USE_TLS = true;
      PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
      PAPERLESS_DISABLE_REGULAR_LOGIN = true;
      PAPERLESS_SOCIALACCOUNT_ALLOW_SIGNUPS = true;
    };
  };
  services.caddy.virtualHosts."${domain}".extraConfig =
    "reverse_proxy :${toString config.services.paperless.port}";
  backup-dirs = [ config.services.paperless.dataDir ];
  homer.links = [
    {
      name = "Paperless";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/png/paperless-ngx.png";
      url = "https://${domain}";
    }
  ];

}
