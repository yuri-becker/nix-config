{ colmena, nixpkgs, ... }:
specialArgs: hosts: {
  colmenaHive = colmena.lib.makeHive (
    {
      meta = {
        inherit specialArgs;
        nixpkgs = import nixpkgs { system = "x86_64-linux"; };
      };
      defaults = {
        time.timeZone = "Europe/Berlin";
        i18n.defaultLocale = "en_US.UTF-8";
        nix.settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
        deployment.targetUser = null;
      };
    }
    // hosts
  );
  apps = colmena.apps;
}
