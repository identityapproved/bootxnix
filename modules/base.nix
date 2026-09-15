# Base CLI. The archived VM list, plus the lainland CLI stack the zsh rc.d
# modules and aliases assume (eza, delta, yazi, xclip, vivid, ...).
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # archived base
    bat
    curl
    fd
    fzf
    git
    htop
    jq
    lazygit
    netcat-openbsd
    openvpn
    ripgrep
    rsync
    tmux
    tldr
    wget
    zoxide
    # lainland CLI stack
    eza
    delta
    yazi
    btop
    vivid
    fastfetch
    xclip
    feh
    # CLI only: NixOS ships the openssl library in the closure but not the
    # binary, so `openssl x509`/`s_client` are unavailable without this.
    openssl
    unzip
    p7zip
    file
    tree
  ];
}
