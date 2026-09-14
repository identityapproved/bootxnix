# Browsers: firefox, chromium, brave, tor-browser (nixpkgs), plus zen from its
# flake input. The startpage is the homepage for the first three via native
# policy files. Tor is left stock so its fingerprint stays default.
{ config, lib, pkgs, zen-browser, ... }:
let
  pick = name: lib.optional (builtins.hasAttr name pkgs) pkgs.${name};

  startpageUrl = "file:///etc/bootxnix/startpage/index.html";

  chromiumPolicies = builtins.toJSON {
    HomepageLocation = startpageUrl;
    HomepageIsNewTabPage = false;
    RestoreOnStartup = 4;
    RestoreOnStartupURLs = [ startpageUrl ];
    MetricsReportingEnabled = false;
  };

  firefoxPolicies = builtins.toJSON {
    policies = {
      Homepage = { URL = startpageUrl; Locked = false; };
      DisableTelemetry = true;
      DisablePocket = true;
    };
  };

  # zen from the flake input (unwrapped -> wrapped with our homepage prefs).
  zenPkg = zen-browser.packages.${pkgs.stdenv.hostPlatform.system};
  zen = pkgs.wrapFirefox
    (zenPkg.zen-browser-unwrapped or zenPkg.default)
    {
      extraPrefs = ''
        lockPref("browser.startup.homepage", "${startpageUrl}");
        lockPref("browser.startup.page", 1);
      '';
    };
in
{
  environment.systemPackages =
    (pick "firefox")
    ++ (pick "chromium")
    ++ (pick "brave")
    ++ (pick "tor-browser")
    ++ [ zen ];

  # Startpage + Rose Pine browser theme assets, read-only under /etc.
  environment.etc."bootxnix/startpage".source = ../config/startpage;
  environment.etc."bootxnix/themes/zen".source = ../config/browser/zen;
  environment.etc."bootxnix/themes/dark-reader".source = ../config/browser/dark-reader;

  # Native browser policies.
  environment.etc."firefox/policies/policies.json".text = firefoxPolicies;
  environment.etc."chromium/policies/managed/bootxnix.json".text = chromiumPolicies;
  environment.etc."brave/policies/managed/bootxnix.json".text = chromiumPolicies;
}
