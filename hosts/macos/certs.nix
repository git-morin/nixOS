{ primaryUser, config, lib, ... }:
let
  home = "/Users/${primaryUser}";
  certDir = "${home}/.certs";
  caBundle = "${certDir}/ca-bundle.pem";
  trustStoreTargets = [
    {
      kind = "jre";
      name = "dbeaver";
      jreHome = "/Applications/DBeaver.app/Contents/Eclipse/jre/Contents/Home";
    }
    {
      kind = "jre";
      name = "intellij-idea";
      jreHome = "${home}/Applications/IntelliJ IDEA.app/Contents/jbr/Contents/Home";
    }
    {
      kind = "jre";
      name = "burp-suite";
      jreHome = "/Applications/Burp Suite Community Edition.app/Contents/Resources/jre.bundle/Contents/Home";
    }
    {
      kind = "jre";
      name = "zulu-17";
      jreHome = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home";
    }
    {
      kind = "jre";
      name = "zulu-21";
      jreHome = "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home";
    }
  ];

  kindSnippets = {
    jre = target: ''
      {
        JRE_HOME=${lib.escapeShellArg target.jreHome}
        KEYTOOL="$JRE_HOME/bin/keytool"
        STORE="$JRE_HOME/lib/security/cacerts"
        MARKER=${lib.escapeShellArg "${certDir}/.tls-imported-${target.name}"}

        if [ ! -x "$KEYTOOL" ] || [ ! -f "$STORE" ] || [ ! -s ${lib.escapeShellArg caBundle} ]; then
          echo "INFO: Skipping ${target.name} TLS import (JRE or CA bundle missing)"
        else
          FP="$(/usr/bin/shasum -a 256 ${lib.escapeShellArg caBundle} "$STORE" 2>/dev/null | /usr/bin/awk '{print $1}' | /usr/bin/tr -d '\n')"
          if [ "$(/bin/cat "$MARKER" 2>/dev/null)" = "$FP" ]; then
            : # already imported for this bundle / store pair
          else
            echo "[+] Importing Zscaler CA into ${target.name} (JRE cacerts)"
            TMP_CA_DIR="$(mktemp -d)"
            /usr/bin/awk -v dir="$TMP_CA_DIR" '
              /-----BEGIN CERTIFICATE-----/ { idx++; out = dir "/cert-" idx ".pem" }
              out { print > out }
              /-----END CERTIFICATE-----/ { close(out); out = "" }
            ' ${lib.escapeShellArg caBundle}
            for cert in "$TMP_CA_DIR"/cert-*.pem; do
              [ -f "$cert" ] || continue
              alias_name="zscaler-corp-$(basename "$cert" .pem)"
              if ! "$KEYTOOL" -list -alias "$alias_name" \
                    -keystore "$STORE" -storepass changeit >/dev/null 2>&1; then
                "$KEYTOOL" -importcert -noprompt -trustcacerts \
                  -alias "$alias_name" -file "$cert" \
                  -keystore "$STORE" -storepass changeit \
                  || echo "WARNING: Failed to import $cert into ${target.name}"
              fi
            done
            rm -rf "$TMP_CA_DIR"
            printf '%s' "$(/usr/bin/shasum -a 256 ${lib.escapeShellArg caBundle} "$STORE" 2>/dev/null | /usr/bin/awk '{print $1}' | /usr/bin/tr -d '\n')" > "$MARKER"
          fi
        fi
      }
    '';
  };

  importSnippet = target:
    let fn = kindSnippets.${target.kind} or (throw "certs.nix: unknown kind '${target.kind}' for target '${target.name}'");
    in fn target;

  bundleBootstrap = ''
    {
      CERT_DIR=${lib.escapeShellArg certDir}
      CERT_FILE=${lib.escapeShellArg caBundle}
      CERT_URL="$(/bin/cat ${config.sops.secrets.zscaler_ca_url.path})"
      VPN_HOST="$(/bin/cat ${config.sops.secrets.vpn_host.path})"

      if [ ! -d "$CERT_DIR" ]; then
        /bin/mkdir -p "$CERT_DIR"
        /usr/sbin/chown ${primaryUser} "$CERT_DIR"
      fi

      if [ -s "$CERT_FILE" ]; then
        : # bundle already on disk
      else
        echo "[*] Checking VPN connectivity ($VPN_HOST) before Zscaler CA download..."
        if ! /sbin/ping -c 1 -t 3 "$VPN_HOST" >/dev/null 2>&1; then
          echo "WARNING: Cannot reach $VPN_HOST — skipping Zscaler CA download."
          echo "         Connect to VPN and re-run activation to fetch the bundle."
        else
          echo "[*] Downloading Zscaler CA bundle..."
          # --insecure used ONLY for this bootstrap fetch because the
          # Zscaler root is not yet trusted. Do NOT generalize this flag.
          if /usr/bin/curl --insecure --fail --silent --show-error \
              -o "$CERT_FILE" "$CERT_URL" && [ -s "$CERT_FILE" ]; then
            /usr/sbin/chown ${primaryUser} "$CERT_FILE"
            /bin/chmod 644 "$CERT_FILE"
            echo "[+] Zscaler CA bundle downloaded to $CERT_FILE ($(/usr/bin/wc -c < "$CERT_FILE" | /usr/bin/tr -d ' ') bytes)"
          else
            /bin/rm -f "$CERT_FILE"
            echo "WARNING: Failed to download Zscaler CA bundle — leaving disk clean."
          fi
        fi
      fi
    }
  '';
in
{
  system.activationScripts.postActivation.text = lib.mkOrder 1650 (
    bundleBootstrap
    + "\n"
    + lib.concatMapStringsSep "\n" importSnippet trustStoreTargets
  );
}
