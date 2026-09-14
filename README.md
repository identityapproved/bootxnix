# bootxnix

An unprivileged Incus NixOS container for CTF / lab work: suckless desktop
(dwm + st + dmenu + slstatus), a pentest toolset, and a Rose Pine theme, reached
from a trusted laptop over RDP.

This repo is for lab boxes. **This first box uses plain, readable identifiers**
(user `identityapproved`, host/instance `bootxnix`, well-known repo name). A
later, more sensitive box should copy this repo as a reference and obfuscate its
identifiers — the user name, host name and instance name all live in one place
(`hosts/<box>.nix`) so that is a small change.

## Layout

```
flake.nix              nixosConfigurations.bootxnix; inputs: nixpkgs 26.05, zen-browser, penelope
hosts/bootxnix.nix     the only host file; user, hostname, ports (45022 ssh / 45389 rdp), firewall
lib/rose-pine.nix      the palette, single source of truth for the hand-written themes
modules/
  base.nix             CLI base + lainland CLI stack
  languages.nix        python/go/node/rust/lua runtimes
  tooling.nix          pentest tools (guarded by `pick`); penelope pinned, no boot-time installers
  ssh.nix              key-only sshd on 45022
  shell.nix            zsh (oh-my-zsh random theme) + rc.d loader
  tmux.nix / vim.nix   /etc configs; vim is a light nvim-like setup, no plugin manager
  desktop.nix          dwm/st/slstatus (Rose Pine), xrdp session, wallpapers
  browsers.nix         firefox/chromium/brave/tor + zen, startpage homepage
config/                the actual dotfiles/configs shipped read-only under /etc/bootxnix
secrets/               ssh-keys.nix (gitignored); commit the .example only
```

## What runs, and as whom

- **root (stock NixOS services only):** sshd, xrdp/xrdp-sesman, nix-daemon, and
  the container's systemd basics. This repo defines **no** systemd units, timers
  or root scripts of its own.
- **the logged-in user, per RDP session:** the generated session command, dwm,
  slstatus, a `feh` wallpaper loop, and whatever is launched from dwm.
- `/etc/bootxnix/` holds only data (zsh rc.d, wallpapers, startpage, browser
  themes). Nothing there is on `$PATH`.

## Ports

Non-default on purpose: sshd 45022, xrdp 45389. That is obscurity, not the
control — the real gate is the host's nftables forward rule, which only lets the
one laptop reach these two ports. The host's own 22/2222/3389 stay closed.

## dwm keys (mod = Alt)

Alt is the mod so nothing clashes with a Super-based compositor elsewhere.
Because dwm grabs `Alt`+key, some terminal `Alt` shortcuts do not reach apps
inside dwm; notably fzf's `Alt-C` is remapped to `Ctrl-G` in the zsh config.

| key | action |
|---|---|
| Alt+Return | st running tmux (`main`) |
| Alt+Shift+Return | plain st |
| Alt+e | yazi in st |
| Alt+space | dmenu |
| Alt+w | random wallpaper |
| Alt+b | toggle bar |
| Alt+j/k (l/h, Tab) | focus next/prev |
| Alt+Shift+h/j/k/l | swap with master (zoom) |
| Alt+Ctrl+Shift+h/l | shrink/grow master |
| Alt+Ctrl+Shift+j/k | fewer/more masters |
| Alt+t / Alt+f / Alt+n | tile / monocle / cycle layout |
| Alt+v | toggle floating |
| Alt+q / Alt+Shift+q | kill client / quit dwm |
| Alt+1..9 (+Shift) | view / move to tag |
| Alt+comma/period | previous / next tag |

## Deploy

The host side (Incus, the `incusbr0` bridge and the nftables forward rule) is set
up separately; see the kioku note `incus_ctf_container.md`. Once the instance
exists:

```sh
cp secrets/ssh-keys.nix.example secrets/ssh-keys.nix   # add the laptop pubkey
doas incus file push -r ~/github/bootxnix bootxnix/root/
doas incus exec bootxnix -- nixos-rebuild switch --flake path:/root/bootxnix#bootxnix
doas incus exec bootxnix -- passwd identityapproved
doas incus snapshot create bootxnix clean
```

`path:` (not a bare git flake) is required so the gitignored
`secrets/ssh-keys.nix` is seen at build time.

## Archive

The previous contents of this repo — a VirtualBox/Vagrant + nixos-anywhere VM
template — live on the local-only branch `archive/virtualbox` (never pushed).
