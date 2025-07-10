{ config, ... }:
let
  sopsFile = ./monitoring.secrets.yaml;
in
{
  sops.secrets."monitoring/prometheus/remote_write/password" = {
    sopsFile = sopsFile;
    owner = config.users.users.prometheus.name;
  };
  services.prometheus = {
    enable = true;
    port = 40000;
    checkConfig = "syntax-only";
    exporters.node = {
      enable = true;
      port = 40001;
      enabledCollectors = [
        "interrupts"
        "systemd"
      ];
    };
    globalConfig.scrape_interval = "60s";
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
            ];
          }
        ];
        relabel_configs = [
          {
            source_labels = [ "__address_" ];
            regex = ".*";
            target_label = "instance";
            replacement = "mantis";
          }
        ];
      }
      {
        job_name = "caddy";
        static_configs = [ { targets = [ "127.0.0.1:2019" ]; } ];
      }
    ];
    remoteWrite = [
      {
        url = "https://prometheus-prod-24-prod-eu-west-2.grafana.net/api/prom/push";
        basic_auth = {
          username = "2508041";
          password_file = "${config.sops.secrets."monitoring/prometheus/remote_write/password".path}";
        };
      }
    ];
  };
}
