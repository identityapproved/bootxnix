# CTF / pentest tooling. Every entry goes through `pick`, so a package missing
# from the pinned nixpkgs is skipped rather than failing the whole build; check
# `command -v` for anything you expect and fix the attribute name here if it was
# renamed upstream.
#
# Changes from the archived VirtualBox config:
#   - No Burp Suite / jdk17 / jython: proprietary, replaced by ZAP + mitmproxy.
#   - No boot-time systemd installers for penelope/pdtm. They fetched from the
#     network at every boot and hardcoded a home path. penelope is a pinned
#     package below; pdtm is dropped (its tools are packaged individually).
{ pkgs, lib, penelope, ... }:
let
  pick = set: name: lib.optional (builtins.hasAttr name set) (builtins.getAttr name set);

  # penelope: nixpkgs if present, else the pinned flake input built by hand.
  # It is one stdlib-only Python file, so no dependency closure is needed.
  penelopePkg =
    if pkgs ? penelope then pkgs.penelope
    else pkgs.runCommand "penelope" { nativeBuildInputs = [ pkgs.python3 ]; } ''
      install -Dm755 ${penelope}/penelope.py $out/bin/penelope
      patchShebangs $out/bin/penelope
    '';
in
{
  environment.systemPackages =
    # Web proxies (interception). No Burp: free software only.
    builtins.concatLists [
      (pick pkgs "zap")
      (pick pkgs "mitmproxy")
    ]
    # Web / Bug Bounty
    ++ builtins.concatLists [
      (pick pkgs "ffuf")
      (pick pkgs "wfuzz")
      (pick pkgs "gobuster")
      (pick pkgs "feroxbuster")
      (pick pkgs "nikto")
      (pick pkgs "sqlmap")
      (pick pkgs "httpx")
      (pick pkgs "nuclei")
      (pick pkgs "gau")
      (pick pkgs "waybackurls")
      (pick pkgs "arjun")
      (pick pkgs "dalfox")
      (pick pkgs "whatweb")
      (pick pkgs "wpscan")
    ]
    # Recon / Enumeration
    ++ builtins.concatLists [
      (pick pkgs "nmap")
      (pick pkgs "masscan")
      (pick pkgs "amass")
      (pick pkgs "subfinder")
      (pick pkgs "assetfinder")
      (pick pkgs "dnsx")
      (pick pkgs "naabu")
      (pick pkgs "theharvester")
      (pick pkgs "enum4linux-ng")
      (pick pkgs "ldapdomaindump")
    ]
    # AD / Windows / lateral movement
    ++ builtins.concatLists [
      (pick pkgs "impacket")
      (pick pkgs "sshpass")
      (pick pkgs "freerdp")
      (pick pkgs "wireguard-tools")
    ]
    # Exploitation / Frameworks
    ++ builtins.concatLists [
      (pick pkgs "metasploit")
      (pick pkgs "exploitdb")
      (pick pkgs.python3Packages "pwntools")
      (pick pkgs "ropgadget")
      (pick pkgs "gdb")
      [ penelopePkg ]
    ]
    # Crypto / Encoding / Brute Force
    ++ builtins.concatLists [
      (pick pkgs "hashcat")
      (pick pkgs "john")
      (pick pkgs "hydra")
      (pick pkgs "crunch")
      (pick pkgs "hashid")
      (pick pkgs "fcrackzip")
      (pick pkgs "pdfcrack")
    ]
    # Reverse Engineering
    ++ builtins.concatLists [
      (pick pkgs "ghidra")
      (pick pkgs "radare2")
      (pick pkgs "binwalk")
      (pick pkgs "binutils")
      (pick pkgs "patchelf")
      (pick pkgs "ltrace")
      (pick pkgs "strace")
    ]
    # Binary / Pwn
    ++ builtins.concatLists [
      (pick pkgs "checksec")
      (pick pkgs "one_gadget")
      (pick pkgs "libc-database")
      (pick pkgs "qemu")
      (pick pkgs "valgrind")
    ]
    # Network / Traffic
    ++ builtins.concatLists [
      (pick pkgs "tcpdump")
      (pick pkgs "wireshark")
      (pick pkgs "bettercap")
      (pick pkgs "dsniff")
    ]
    # Payloads / Wordlists
    ++ builtins.concatLists [
      (pick pkgs "seclists")
      (pick pkgs "wordlists")
      (pick pkgs "payloadsallthethings")
    ];
}
