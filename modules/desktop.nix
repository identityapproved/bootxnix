# X + suckless desktop, reached over xrdp. dwm/st/slstatus are the nixpkgs
# packages with our config: dwm via the `conf` argument (full config.h), st and
# slstatus via postPatch edits so a version bump doesn't need a new whole file.
{ config, lib, pkgs, ... }:
let
  dwm = pkgs.dwm.override {
    conf = builtins.readFile ../config/suckless/dwm/config.h;
  };

  # st and slstatus ship a full, version-matched config.def.h (the Makefile
  # copies config.def.h -> config.h). Full files instead of in-place edits so
  # there is no regex fragility; re-check them only if upstream bumps the
  # config layout.
  st = pkgs.st.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      cp ${../config/suckless/st/config.h} config.def.h
    '';
  });

  slstatus = pkgs.slstatus.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      cp ${../config/suckless/slstatus/config.h} config.def.h
    '';
  });

  # The one script in the repo: xrdp needs a single session command, generated
  # into the store. Runs as the logged-in user.
  session = pkgs.writeShellScript "bootxnix-session" ''
    export PATH=${lib.makeBinPath [ pkgs.feh slstatus pkgs.coreutils dwm pkgs.setxkbmap ]}:$PATH
    # Keymap: xrdp/xorgxrdp pushes the client's keymap into the session *after*
    # this script starts, clobbering both services.xserver.xkb and a one-shot
    # setxkbmap here (confirmed: slstatus was running but `setxkbmap -query`
    # showed no options). So set it now and re-assert it over the first ~10s,
    # by which point xrdp has finished.
    bootxnix_keymap() {
      setxkbmap -layout us -option caps:swapescape
    }
    bootxnix_keymap
    ( for d in 1 2 3 5; do sleep "$d"; bootxnix_keymap; done ) &
    feh --no-fehbg --randomize --bg-fill /etc/bootxnix/wallpapers
    ( while sleep 900; do feh --no-fehbg --randomize --bg-fill /etc/bootxnix/wallpapers; done ) &
    slstatus &
    exec dwm
  '';
in
{
  services.xserver = {
    enable = true;
    windowManager.dwm.enable = true;
    windowManager.dwm.package = dwm;
    displayManager.startx.enable = true; # no greeter; xrdp drives the session

    # Caps and Escape swapped, as on every other machine here. Over RDP the
    # client sends scancodes and the *remote* side decides what they mean, so
    # without this the laptop's swap does not carry into the session and Caps
    # behaves as Caps inside dwm/vim.
    #
    # US only, and no group toggle: this box is reached over RDP from one
    # laptop and does not need the ua layout.
    #
    # This alone is not enough - xrdp overrides it at session start; the real
    # enforcement is the setxkbmap re-assert in the session script below.
    xkb = {
      layout = "us";
      options = "caps:swapescape";
    };
  };

  services.xrdp = {
    enable = true;
    port = config.bootxnix.rdpPort;
    openFirewall = false; # host nftables + hosts/bootxnix.nix gate the port
    defaultWindowManager = "${session}";
  };

  environment.systemPackages = [ st slstatus dwm pkgs.dmenu pkgs.feh pkgs.xclip pkgs.xterm ];

  # Read-only data under /etc/bootxnix.
  environment.etc."bootxnix/wallpapers".source = ../config/wallpapers;

  fonts.packages = with pkgs; [
    nerd-fonts.anonymice
    nerd-fonts.symbols-only
    noto-fonts
  ];
}
