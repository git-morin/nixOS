{ primaryUser, config, ... }:
let
  home = "/Users/${primaryUser}";
  mavenSettingsPath = "${home}/b2b-identity/devops/brewfile/settings.xml";
  dbeaverDataSourcesPath = "${home}/b2b-identity/devops/brewfile/dbeaver-data-sources.json";
in
{
  sops = {
    age.keyFile = "${home}/.config/sops/age/keys.txt";
    age.sshKeyPaths = [];
    gnupg.sshKeyPaths = [];
    defaultSopsFile = ../../secrets/team.yaml;
    secrets.npm_ticketmaster_registry = {};
    secrets.npm_tm1_registry = {};
    secrets.zscaler_ca_url = {};
    secrets.splunk_nonprod_token = {};
  };

  system.activationScripts.postActivation.text = ''
    M2_SETTINGS="${home}/.m2/settings.xml"
    if [ ! -f "$M2_SETTINGS" ]; then
      if [ -f "${mavenSettingsPath}" ]; then
        mkdir -p "${home}/.m2"
        cp "${mavenSettingsPath}" "$M2_SETTINGS"
      else
        echo "WARNING: Maven settings not found at ${mavenSettingsPath}"
      fi
    fi

    DBEAVER_WORKSPACE="${home}/Library/DBeaverData/workspace6/General/.dbeaver"
    DBEAVER_DATASOURCES="$DBEAVER_WORKSPACE/data-sources.json"
    if [ ! -f "$DBEAVER_DATASOURCES" ]; then
      if [ -f "${dbeaverDataSourcesPath}" ]; then
        mkdir -p "$DBEAVER_WORKSPACE"
        cp "${dbeaverDataSourcesPath}" "$DBEAVER_DATASOURCES"
        chown -R ${primaryUser} "$(dirname "$DBEAVER_WORKSPACE")" "$DBEAVER_WORKSPACE" "$DBEAVER_DATASOURCES"
      else
        echo "WARNING: DBeaver data sources not found at ${dbeaverDataSourcesPath}"
      fi
    fi

    # DBeaver cannot resolve Maven Central SSL certs behind the corporate proxy (PKIX error),
    # so drivers are downloaded manually via curl.
    DBEAVER_DRIVER_BASE="${home}/Library/DBeaverData/drivers/maven/unknown"
    MAVEN_BASE="https://repo1.maven.org/maven2"
    declare -A DBEAVER_JARS=(
      ["org.postgresql/postgresql-42.7.2.jar"]="org/postgresql/postgresql/42.7.2/postgresql-42.7.2.jar"
      ["net.postgis/postgis-jdbc-2.5.0.jar"]="net/postgis/postgis-jdbc/2.5.0/postgis-jdbc-2.5.0.jar"
      ["net.postgis/postgis-geometry-2.5.0.jar"]="net/postgis/postgis-geometry/2.5.0/postgis-geometry-2.5.0.jar"
      ["com.github.waffle/waffle-jna-1.9.1.jar"]="com/github/waffle/waffle-jna/1.9.1/waffle-jna-1.9.1.jar"
    )
    for target_path in "''${!DBEAVER_JARS[@]}"; do
      mkdir -p "$DBEAVER_DRIVER_BASE/$(dirname "$target_path")"
      if [ ! -f "$DBEAVER_DRIVER_BASE/$target_path" ]; then
        /usr/bin/curl -fsSL -o "$DBEAVER_DRIVER_BASE/$target_path" \
          "$MAVEN_BASE/''${DBEAVER_JARS[$target_path]}" \
          || echo "WARNING: Failed to download DBeaver driver $target_path"
      fi
    done

    # Splunk CLI env vars (avoids keyring issues during activation)
    SPLUNK_ENV="${home}/.config/secrets/splunk.sh"
    mkdir -p "$(dirname "$SPLUNK_ENV")"
    cat > "$SPLUNK_ENV" <<SPLUNKEOF
export SPLUNK_HOST="splunk.nonprod.tktm.io"
export SPLUNK_TOKEN="$(cat ${config.sops.secrets.splunk_nonprod_token.path})"
SPLUNKEOF
    chown ${primaryUser} "$SPLUNK_ENV"
    chmod 600 "$SPLUNK_ENV"

    if command -v npm &>/dev/null; then
      npm config set @ticketmaster:registry="$(cat ${config.sops.secrets.npm_ticketmaster_registry.path})"
      npm config set @tm1:registry="$(cat ${config.sops.secrets.npm_tm1_registry.path})"
    fi
  '';
}
