{
  config,
  lib,
  pkgs,
  ...
}:
let
  sopsFile = ./beszel-agent.secrets.yaml;
  unitName = "beszel-agent";
  secretNs = "beszel_agent";
  secrets = {
    hubUrl = "${secretNs}/hub_url";
    publicKey = "${secretNs}/public_key";
    token = "${secretNs}/token";
  };
  stateDir = "/var/lib/beszel-agent";
in
{
  sops.secrets = lib.mapAttrs' (
    _: value:
    lib.nameValuePair value {
      inherit sopsFile;
      restartUnits = [ "${unitName}.service" ];
    }
  ) secrets;

  sops.templates."beszel-agent.env".content = ''
    DATA_DIR=${stateDir}/data
    DOCKER_HOST=
    HUB_URL=${config.sops.placeholder.${secrets.hubUrl}}
    KEY=${config.sops.placeholder.${secrets.publicKey}}
    LISTEN=127.0.0.1:45876
    TOKEN=${config.sops.placeholder.${secrets.token}}
  '';

  systemd.services.${unitName} = {
    description = "Beszel Agent Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      StateDirectory = baseNameOf stateDir;
      EnvironmentFile = config.sops.templates."beszel-agent.env".path;
      ExecStart = "${pkgs.beszel}/bin/beszel-agent";
      Restart = "on-failure";
      KeyringMode = "private";
      LockPersonality = "yes";
      NoNewPrivileges = "yes";
      ProtectClock = "yes";
      ProtectHome = "read-only";
      ProtectHostname = "yes";
      ProtectKernelLogs = "yes";
      ProtectSystem = "strict";
      RemoveIPC = "yes";
      RestrictSUIDSGID = true;
    };
  };
}
