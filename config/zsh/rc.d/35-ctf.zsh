# CTF / HTB / THM workflow helpers. Native reimplementations of the docker-based
# serve helpers from refs/maxos-legacy (bootxnix has no docker): the tools they
# wrapped - impacket, penelope, python3 - are installed directly here. Loaded
# after 30-functions.zsh by the rc.d loop in modules/shell.nix.

# Set the current target: exports IP/RHOST and stashes it so a new shell can
# pick it back up. `target 10.10.10.10`, then `$IP` / `$RHOST` everywhere.
target() {
  if (( $# )); then
    export IP="$1" RHOST="$1"
    print -r -- "$1" > "${TMPDIR:-/tmp}/target"
    echo "target=$1"
  elif [[ -r "${TMPDIR:-/tmp}/target" ]]; then
    export IP="$(<"${TMPDIR:-/tmp}/target")" RHOST="$IP"
    echo "target=$IP"
  else
    echo "usage: target <ip>"; return 1
  fi
}

# HTB/THM VPN address at a glance (pairs with the `myip` alias).
tun() { ip -br a show tun0 2>/dev/null || echo "tun0 down"; }

# Serve the current directory over HTTP. `serve` or `serve 8080` (default 8000).
serve()     { python3 -m http.server "${1:-8000}"; }
httpserve() { serve "$@"; }

# Serve the current directory over SMB for file transfer to a target.
# Port 445 is privileged: run under sudo (wheel has it, with a password).
#   smbserve            -> share name SHARE
#   smbserve loot       -> share name loot
smbserve() {
  local share="${1:-SHARE}"
  echo "smb://<you>:445/${share}  ->  $PWD  (needs sudo for :445)"
  impacket-smbserver -smb2support "$share" "$PWD"
}

# Reverse-shell listener via penelope (auto-upgrades the shell). `listen` or
# `listen 9001` (default 4444).
listen() { penelope "${1:-4444}"; }
