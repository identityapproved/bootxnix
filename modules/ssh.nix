# SSH, hardened. Adapted from ~/github/nixlabdots/modules/ssh.nix: key-only,
# single user, no forwarding. Port comes from hosts/bootxnix.nix (45022).
#
# Configured but NOT running by default, same as g33nto's own sshd: the desktop
# arrives over RDP, and ssh is started from inside that session when it is
# actually wanted:
#
#   sudo systemctl start sshd     # open it
#   sudo systemctl stop  sshd     # close it again
#   systemctl is-active  sshd
{ config, lib, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ config.bootxnix.sshPort ];
    openFirewall = false; # the host firewall + hosts/bootxnix.nix gate the port

    # Persistent daemon rather than socket activation. The socket-activated
    # path (the 26.05 default) leaves sshd.socket reporting "active
    # (listening)" while holding no file descriptors after a rebuild changes
    # the unit - "Unit configuration changed while unit was running ... not
    # functional until restarted" - so the port stops accepting silently. A
    # plain sshd.service is also the thing `systemctl start` acts on cleanly.
    startWhenNeeded = false;

    settings = {
      AllowUsers = [ config.bootxnix.user ];
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
      AuthenticationMethods = "publickey";
      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = false;
      PermitTunnel = false;
      AllowStreamLocalForwarding = false;
      MaxAuthTries = 3;
      MaxSessions = 2;
      LoginGraceTime = "30s";
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      UseDns = false;
      PrintMotd = false;
    };
  };

  # Do not start at boot: nothing listens on the ssh port until it is started
  # by hand from the RDP session. The host forward rule still permits the port
  # from the laptop only, so starting it exposes it to that one address.
  systemd.services.sshd.wantedBy = lib.mkForce [ ];
}
