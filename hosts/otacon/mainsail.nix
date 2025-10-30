{ ... }:
{
  services.mainsail.enable = true;
  services.mainsail.nginx.extraConfig = ''
    client_max_body_size 1000M;
  '';
  networking.firewall.allowedTCPPorts = [ 80 ];
}
