{ ... }:
{
  programs.librewolf = {
    enable = true;
    languagePacks = [
      "en-GB"
      "de"
    ];
    enableGnomeExtensions = true;
    profiles.work = {
      search = {
        force = true;
        default = "kagi";
        engines.kagi = {
          name = "Kagi";
          urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
          icon = "https://kagi.com/favicon.ico";
        };
      };
    };
  };
}
