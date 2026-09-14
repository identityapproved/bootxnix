# SSH, hardened. Adapted from ~/github/nixlabdots/modules/ssh.nix: key-only,
# single user, no forwarding. Port comes from hosts/bootxnix.nix (45022).
{ config, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ config.bootxnix.sshPort ];
    openFirewall = false; # the host firewall + hosts/bootxnix.nix gate the port

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
}
