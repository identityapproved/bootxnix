# Chromium/Brave managed-extension set, copied deliberately from
# /mnt/ctfstick/kali_configuration/config/brave/extensions.json (external media;
# not referenced from the flake). Consumed by modules/browsers.nix as the
# ExtensionSettings block for both Chromium and Brave. installation_mode is
# "normal_installed" so each can still be disabled or removed by hand.
#
# CRX ids include uBlock Origin, FoxyProxy Standard, Wappalyzer, Cookie-Editor
# and other web-recon helpers. Firefox/Zen use a separate AMO-slug policy in
# modules/browsers.nix (Zen deliberately carries no pentest extensions).
{
  "*" = { installation_mode = "allowed"; };
  "ojpilaklfjcfpehafidhijapphckbbbo" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "gcknhkkoolaabfmlnjonogaaifnjlfnp" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "gppongmhjkpfnbhagpmjfkannfbllamg" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "inojafojbhdpnehkhhfjalgjjobnhomj" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "hgmhmanijnjhaffoampdlllchpolkdnj" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "cmbndhnoonmghfofefkcccljbkdpamhi" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "ojfebgpkimhlhcblbalbfjblapadhbol" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "fjkmabmdepjfammlpliljpnbhleegehm" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "bpjdkodgnbfalgghnbeggfbfjpcfamkf" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "kfhniponecokdefffkpagipffdefeldb" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "pampamgoihgcedonnphgehgondkhikel" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "oifijhaokejakekmnjmphonojcfkpbbh" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "omanlgcpomfhgbfnlhmfilokfggfpblb" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "mmbhfeiddhndihdjeganjggkmjapkffm" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "fpnmgdkabkmnadcjpehmlllkndpkmiak" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "jjalcfnidlmpjhdfepjhjbhnhkbgleap" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "ppliilneafplhagjhhphcjmjdmbjagcp" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "anngjobjhcbancaaogmlcffohpmcniki" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "gncnbkghencmkfgeepfaonmegemakcol" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "bfjbejmeoibbdpfdbmbacmefcbannnbg" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "mnakbpdnkedaegeiaoakkjafhoidklnf" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "cidlcjdalomndpeagkjpnefhljffbnlo" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "lkpfjhmpbmpflldmdpdoabimdbaclolp" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "eimadpbcbfnmbkopoojfekhnkhdbieeh" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "hfjbmagddngcpeloejdejnfgbamkjaeg" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
  "dhildnnjbegaggknfkagdpnballiepfm" = { installation_mode = "normal_installed"; update_url = "https://clients2.google.com/service/update2/crx"; };
}
