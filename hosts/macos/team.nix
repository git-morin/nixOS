{ ... }:
let
  mavenSettingsPath = "$HOME/b2b-identity/devops/brewfile/settings.xml";
  dbeaverDataSourcesPath = "$HOME/b2b-identity/devops/brewfile/dbeaver-data-sources.json";
in
{
  system.activationScripts.postActivation.text = ''
    M2_SETTINGS="$HOME/.m2/settings.xml"
    if [ ! -f "$M2_SETTINGS" ]; then
      if [ -f "${mavenSettingsPath}" ]; then
        mkdir -p "$HOME/.m2"
        cp "${mavenSettingsPath}" "$M2_SETTINGS"
      else
        echo "WARNING: Maven settings not found at ${mavenSettingsPath}"
      fi
    fi

    DBEAVER_WORKSPACE="$HOME/Library/DBeaverData/workspace6/General/.dbeaver"
    DBEAVER_DATASOURCES="$DBEAVER_WORKSPACE/data-sources.json"
    if [ ! -f "$DBEAVER_DATASOURCES" ]; then
      if [ -f "${dbeaverDataSourcesPath}" ]; then
        mkdir -p "$DBEAVER_WORKSPACE"
        cp "${dbeaverDataSourcesPath}" "$DBEAVER_DATASOURCES"
      else
        echo "WARNING: DBeaver data sources not found at ${dbeaverDataSourcesPath}"
      fi
    fi

    # DBeaver cannot resolve Maven Central SSL certs behind the corporate proxy (PKIX error),
    # so drivers are downloaded manually via curl.
    DBEAVER_DRIVER_BASE="$HOME/Library/DBeaverData/drivers/maven/unknown"
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

    NPM_REGISTRIES="$HOME/.config/secrets/npm-registries.sh"
    if command -v npm &>/dev/null; then
      if [ -f "$NPM_REGISTRIES" ]; then
        bash "$NPM_REGISTRIES"
      else
        echo "WARNING: npm registries not configured — create $NPM_REGISTRIES"
      fi
    fi
  '';
}
