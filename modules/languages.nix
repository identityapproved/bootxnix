# Language runtimes, salvaged as-is from the archived config.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lua
    luarocks
    nodejs
    pipx
    python3
    rustup
    uv
    go
  ];
}
