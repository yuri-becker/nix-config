{
  config,
  lib,
  ...
}:
{
  options.actual.domain =
    with lib;
    mkOption {
      type = types.str;
      default = "budget.home.arpa";
    };

  config = {
    services.actual = {
      enable = true;
      openFirewall = false;
      settings = {
      };
    };

    services.caddy.virtualHosts."${config.actual.domain}".extraConfig =
      "reverse_proxy :${toString config.services.actual.settings.port}";
    services.borgmatic.configurations.mantis.source_directories = [
      config.services.actual.settings.dataDir
    ];
    homer.links = [
      {
        name = "Actual Budget";
        logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/actual-budget.png";
        url = "https://${config.actual.domain}";
      }
    ];
  };
}
