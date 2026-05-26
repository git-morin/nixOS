{ primaryUser, lib, pkgs, ... }:
let
  home = "/Users/${primaryUser}";
  keyFile = "${home}/.config/sops/age/keys.txt";
  gitlabProject = "Gabriel.Morin%2Fsops-key";
  gitlabRef = "main";
  blobName = "keys.txt.age";

  fetchScript = ''
    (
      if [ -s "${keyFile}" ]; then
        exit 0
      fi

      echo "fetching sops age key from gitlab..." >&2

      PASSPHRASE=$(/usr/bin/sudo -H -u ${primaryUser} /usr/bin/security find-generic-password \
        -a "${primaryUser}" -s "sops-key-passphrase" -w 2>/dev/null) || {
        echo "WARNING: passphrase not in keychain; falling back to existing keys.txt" >&2
        exit 0
      }

      GLAB_TOKEN_FILE=/run/secrets/glab_token
      GITLAB_HOST_FILE=/run/secrets/gitlab_host
      if [ ! -r "$GLAB_TOKEN_FILE" ] || [ ! -r "$GITLAB_HOST_FILE" ]; then
        echo "WARNING: glab_token/gitlab_host not yet provisioned; using existing keys.txt" >&2
        exit 0
      fi

      GLAB_TOKEN=$(cat "$GLAB_TOKEN_FILE")
      GITLAB_HOST=$(cat "$GITLAB_HOST_FILE")

      TMP_BLOB=$(mktemp)
      trap 'rm -f "$TMP_BLOB"' EXIT

      if ! ${pkgs.curl}/bin/curl -sfL \
        -H "PRIVATE-TOKEN: $GLAB_TOKEN" \
        "https://$GITLAB_HOST/api/v4/projects/${gitlabProject}/repository/files/${blobName}/raw?ref=${gitlabRef}" \
        -o "$TMP_BLOB"; then
        echo "WARNING: failed to fetch keys.txt.age from gitlab; using existing keys.txt" >&2
        exit 0
      fi

      mkdir -p "$(dirname ${keyFile})"

      if ! ${pkgs.expect}/bin/expect <<EOF >&2
set timeout 15
log_user 0
spawn ${pkgs.age}/bin/age -d -o ${keyFile} $TMP_BLOB
expect "Enter passphrase:"
send "$PASSPHRASE\r"
expect eof
catch wait result
exit [lindex \$result 3]
EOF
      then
        echo "ERROR: failed to decrypt keys.txt.age" >&2
        exit 1
      fi

      chown ${primaryUser} ${keyFile}
      chmod 600 ${keyFile}
      echo "sops age key materialized at ${keyFile}" >&2
    ) || true
  '';

in
{
  system.activationScripts.postActivation.text = lib.mkBefore fetchScript;
}
