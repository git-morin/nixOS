{ lib, ... }:
{
  system.activationScripts.postActivation.text = lib.mkOrder 1900 ''
    {
      NH_BIN="/run/current-system/sw/bin/nh"
      if [ -x "$NH_BIN" ]; then
        echo "[+] Pruning generations (keep last 5) and running nix store GC"
        "$NH_BIN" clean all -k 5 2>&1 | /usr/bin/sed 's/^/    /' \
          || echo "WARNING: nh clean failed (non-fatal); skip and continue"
      else
        echo "INFO: $NH_BIN not found; skipping auto-GC"
      fi
    }
  '';
}
