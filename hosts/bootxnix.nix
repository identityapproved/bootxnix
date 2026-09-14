# bootxnix: the one host file. Every identifying value for this box lives here
# as a `let` binding; the modules read them through the `bootxnix` options
# below instead of hardcoding a name or port. A later, obfuscated lab box is a
# copy of this file with the four values changed and nothing else touched.
{ config, lib, pkgs, modulesPath, ... }:

let
  user = "identityapproved";
  host = "bootxnix";
  sshPort = 45022;
  rdpPort = 45389;
in
{
  imports = [
    (modulesPath + "/virtualisation/lxc-container.nix")
    ../modules/base.nix
    ../modules/languages.nix
    ../modules/tooling.nix
    ../modules/ssh.nix
    ../modules/shell.nix
    ../modules/tmux.nix
    ../modules/vim.nix
    ../modules/desktop.nix
    ../modules/browsers.nix
  ];

  # Read by the modules; see modules/*.nix.
  options.bootxnix = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary interactive user for this lab box.";
    };
    sshPort = lib.mkOption { type = lib.types.port; };
    rdpPort = lib.mkOption { type = lib.types.port; };
  };

  config = {
    bootxnix = { inherit user sshPort rdpPort; };

    networking.hostName = host;

    users.mutableUsers = true;
    users.users.${user} = {
      isNormalUser = true;
      description = user;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = import ../secrets/ssh-keys.nix;
    };
    # Passwordless doas/sudo would let a popped RDP session escalate silently;
    # wheel keeps the password prompt. The password is set imperatively after
    # deploy (incus exec ... passwd), so no hash is committed.
    security.sudo.wheelNeedsPassword = true;

    # Inner firewall layer. eth0 faces incusbr0; the host's nftables forward
    # chain is the real gate. Only the two service ports are reachable there.
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ sshPort rdpPort ];
      # HTB/THM reverse shells and payload servers arrive over the VPN tun,
      # which never crosses the host forward rules. Open the unprivileged
      # range on tun* only, never on eth0.
      interfaces."tun0".allowedTCPPortRanges = [ { from = 1024; to = 65535; } ];
      interfaces."tun0".allowedUDPPortRanges = [ { from = 1024; to = 65535; } ];
    };

    # The zsh config is system-wide (/etc/bootxnix/zsh, read-only), so the user
    # never needs a writable ~/.zshrc. An empty one stops zsh-newuser-install
    # from prompting on first login. No literal home path: derived from the
    # account NixOS created.
    systemd.tmpfiles.rules = [
      "f ${config.users.users.${user}.home}/.zshrc 0644 ${user} ${config.users.users.${user}.group} -"
    ];

    time.timeZone = "UTC";
    i18n.defaultLocale = "en_US.UTF-8";

    system.stateVersion = "26.05";
  };
}
