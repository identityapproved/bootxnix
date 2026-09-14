# X + suckless desktop, reached over xrdp. dwm/st/slstatus are the nixpkgs
# packages with our config: dwm via the `conf` argument (full config.h), st and
# slstatus via postPatch edits so a version bump doesn't need a new whole file.
{ config, lib, pkgs, ... }:
let
  dwm = pkgs.dwm.override {
    conf = builtins.readFile ../config/suckless/dwm/config.h;
  };

  st = pkgs.st.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      ${pkgs.gawk}/bin/awk -f ${../config/suckless/st.awk} config.def.h > config.def.h.new
      mv config.def.h.new config.def.h
      sed -i 's/^static char \*font = .*/static char *font = "AnonymicePro Nerd Font Mono:pixelsize=14:antialias=true:autohint=true";/' config.def.h
    '';
  });

  slstatus = pkgs.slstatus.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      ${pkgs.gawk}/bin/awk -f ${../config/suckless/slstatus.awk} config.def.h > config.def.h.new
      mv config.def.h.new config.def.h
    '';
  });

  # The one script in the repo: xrdp needs a single session command, generated
  # into the store. Runs as the logged-in user.
  session = pkgs.writeShellScript "bootxnix-session" ''
    export PATH=${lib.makeBinPath [ pkgs.feh slstatus pkgs.coreutils dwm ]}:$PATH
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
