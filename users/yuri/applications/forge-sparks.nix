{
  config,
  lib,
  pkgs,
  ...
}:
let
  accounts = {
    "0ea5d125-ac18-4ed1-a93d-3246f309e074" = {
      enable = config.localhost.work.enable;
      forge = "forgejo";
      url = "git.alt.coop";
      user-id = 1;
      username = "yuri";
    };
  };
  enabledAccounts = lib.filterAttrs (name: value: value.enable) accounts;
in
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    home.packages = [ pkgs.forge-sparks ];

    dconf.settings = {
      "com/mardojai/ForgeSparks" = {
        accounts = builtins.attrNames enabledAccounts;
        autostart = true;
        autostart-hidden = true;
        first-run = true;
        hide-on-close = true;
      };
    }
    // lib.genAttrs' (lib.attrNames enabledAccounts) (
      accountId:
      lib.nameValuePair ("com/mardojai/ForgeSparks/" + accountId) {
        inherit (enabledAccounts.${accountId})
          forge
          url
          user-id
          username
          ;
      }
    );
  };
}
