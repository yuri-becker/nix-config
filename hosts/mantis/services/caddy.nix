{ config, pkgs, ... }:
let
  certDomain = "cert.home.arpa";
in
{
  services.caddy = {
    enable = true;
    globalConfig = ''
      local_certs
      metrics {
        per_host
      }
    '';
    virtualHosts."${certDomain}:80".extraConfig = ''
      file_server {
        root /var/lib/caddy/.local/share/caddy/pki/authorities/local
      }
      rewrite * root.crt
      header Content-Disposition "attachment; filename=root.crt"
    '';
    virtualHosts."${certDomain}:443".extraConfig = "redir http://${certDomain}";
    virtualHosts."ha.home.arpa".extraConfig = "reverse_proxy 192.168.0.10:80";
  };
  users.users."${config.services.caddy.user}".packages = with pkgs; [
    nss
    nss.tools
  ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.borgmatic.configurations.mantis.source_directories = [ config.services.caddy.dataDir ];
}
