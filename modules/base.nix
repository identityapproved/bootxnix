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
    unzip
    p7zip
    file
    tree
  ];
}
