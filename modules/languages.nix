# Language runtimes, salvaged from the archived config.
#
# No pipx: `uvx <tool>` covers ephemeral Python tools and `uv` project envs, and
# pipx 1.8.0 fails its own test suite on nixpkgs 26.05 (a `packaging` bump
# changed canonical spec spacing). penelope, the one tool the old config
# installed via pipx, is a proper package in modules/tooling.nix now.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lua
    luarocks
    nodejs
    python3
    rustup
    uv
    go
  ];
}
