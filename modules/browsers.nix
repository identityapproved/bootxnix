# Browsers: firefox, chromium, brave, tor-browser (nixpkgs), plus zen from its
# flake input. The startpage is the homepage for the first three via native
# policy files. Tor is left stock so its fingerprint stays default.
{ config, lib, pkgs, zen-browser, ... }:
let
  pick = name: lib.optional (builtins.hasAttr name pkgs) pkgs.${name};

  startpageUrl = "file:///etc/bootxnix/startpage/index.html";

  # Firefox/Zen install extensions by AMO slug -> latest signed xpi.
  amo = slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";

  # Chromium/Brave pentest extension set (CRX ids), copied from the Kali policy.
  chromiumExtensions = import ../config/browser/chromium-extensions.nix;

  chromiumPolicies = builtins.toJSON {
    HomepageLocation = startpageUrl;
    HomepageIsNewTabPage = false;
    RestoreOnStartup = 4;
    RestoreOnStartupURLs = [ startpageUrl ];
    MetricsReportingEnabled = false;
    ExtensionSettings = chromiumExtensions;
  };

  # Firefox: the pentest/web-recon set. Zen gets its own set below and is
  # deliberately kept clean (no proxy/recon extensions). IDs must match the
  # add-on's real extension id; verify any additions against about:debugging.
  firefoxPolicies = builtins.toJSON {
    policies = {
      Homepage = { URL = startpageUrl; Locked = false; };
      DisableTelemetry = true;
      DisablePocket = true;
      ExtensionSettings = {
        "*" = { installation_mode = "allowed"; };
        "uBlock0@raymondhill.net"   = { installation_mode = "normal_installed"; install_url = amo "ublock-origin"; };
        "foxyproxy@eric.h.jung"     = { installation_mode = "normal_installed"; install_url = amo "foxyproxy-standard"; };
        "wappalyzer@crunchlabz.com" = { installation_mode = "normal_installed"; install_url = amo "wappalyzer"; };
      };
    };
  };

  # Zen: privacy / daily-driver browser. No proxy or pentest extensions by
  # design - Dark Reader, uBlock, NoScript, Bitwarden, Vimium C, plus WebRTC
  # disabled (media.peerconnection.enabled) in the wrapper prefs below.
  zenPolicies = {
    DisableTelemetry = true;
    DisablePocket = true;
    ExtensionSettings = {
      "*" = { installation_mode = "allowed"; };
      "addon@darkreader.org"                     = { installation_mode = "normal_installed"; install_url = amo "darkreader"; };
      "uBlock0@raymondhill.net"                  = { installation_mode = "normal_installed"; install_url = amo "ublock-origin"; };
      "{73a6fe31-595d-460b-a920-fcc0f8843232}"   = { installation_mode = "normal_installed"; install_url = amo "noscript"; };            # NoScript
      "{446900e4-71c2-419f-a6a7-df9c091e268b}"   = { installation_mode = "normal_installed"; install_url = amo "bitwarden-password-manager"; };
      "{d7742d87-e61d-4b78-b8a1-b469842139fa}"   = { installation_mode = "normal_installed"; install_url = amo "vimium-c"; };            # Vimium C (verify id)
    };
  };

  # zen from the flake input (unwrapped -> wrapped with our homepage prefs).
  zenPkg = zen-browser.packages.${pkgs.stdenv.hostPlatform.system};
  zen = pkgs.wrapFirefox
    (zenPkg.zen-browser-unwrapped or zenPkg.default)
    {
      extraPolicies = zenPolicies;
      extraPrefs = ''
        lockPref("browser.startup.homepage", "${startpageUrl}");
        lockPref("browser.startup.page", 1);
        // Privacy browser: no WebRTC (prevents local/VPN IP leaks).
        lockPref("media.peerconnection.enabled", false);
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
