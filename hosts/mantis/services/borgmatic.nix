{ config, pkgs, ... }:
let
  sopsFile = ./borgmatic.secrets.yaml;
in
{
  sops.secrets."borgmatic/encryption_password".sopsFile = sopsFile;
  services.borgmatic = {
    enable = true;
    configurations.mantis = {
      postgresql_databases = [
        {
          name = "all";
          pg_dump_command = "${pkgs.postgresql}/bin/pg_dumpall";
          pg_restore_command = "${pkgs.postgresql}/bin/pg_restore";
        }
      ];
      exclude_if_present = [ ".nobackup" ];
      repositories = [
        {
          path = "ssh://w0xy1x36@w0xy1x36.repo.borgbase.com/./repo";
          label = "borgbase";
        }
      ];
      numeric_ids = true;
      keep_daily = 7;
      keep_weekly = 4;
      keep_monthly = 12;
      keep_yearly = 10;
      encryption_passcommand = "cat ${config.sops.secrets."borgmatic/encryption_password".path}";
      ssh_command = "ssh -i ~/.ssh/id_borgbase";
      archive_name_format = "mantis-{now}";
      compression = "lzma";
    };
  };
  services.postgresql.ensureUsers = [
    {
      name = "root";
      ensureClauses.superuser = true;
    }
  ];
}
