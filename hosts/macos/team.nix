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
    secrets.databricks_host_nonprod = {};
    secrets.databricks_host_preprod = {};
    secrets.databricks_host_prod = {};
    secrets.databricks_account_id = {};
    secrets.databricks_workspace_id_preprod = {};
    secrets.databricks_workspace_id_prod = {};
    secrets.techops_password = {};
    secrets.jira_mcp_token = {};
    secrets.jira_mcp_url = {};
    secrets.glab_token = {};
    secrets.gitlab_host = {};
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

    # Databricks CLI config
    DATABRICKS_CFG="${home}/.databrickscfg"
    cat > "$DATABRICKS_CFG" <<DATABRICKSEOF
; The profile defined in the DEFAULT section is to be used as a fallback when no profile is explicitly specified.
[DEFAULT]

[ticketmaster-tm1-nonprod]
host      = $(cat ${config.sops.secrets.databricks_host_nonprod.path})
auth_type = databricks-cli

[ticketmaster-tm1-preprod]
host         = $(cat ${config.sops.secrets.databricks_host_preprod.path})
auth_type    = databricks-cli
account_id   = $(cat ${config.sops.secrets.databricks_account_id.path})
workspace_id = $(cat ${config.sops.secrets.databricks_workspace_id_preprod.path})

[ticketmaster-tm1]
host         = $(cat ${config.sops.secrets.databricks_host_prod.path})
auth_type    = databricks-cli
account_id   = $(cat ${config.sops.secrets.databricks_account_id.path})
workspace_id = $(cat ${config.sops.secrets.databricks_workspace_id_prod.path})

[__settings__]
default_profile = ticketmaster-tm1-nonprod
DATABRICKSEOF
    chown ${primaryUser} "$DATABRICKS_CFG"
    chmod 600 "$DATABRICKS_CFG"

    # glab CLI config (GitLab token + host injected from sops)
    GLAB_CFG_DIR="${home}/Library/Application Support/glab-cli"
    GLAB_CFG="$GLAB_CFG_DIR/config.yml"
    GITLAB_HOST="$(cat ${config.sops.secrets.gitlab_host.path})"
    mkdir -p "$GLAB_CFG_DIR"
    cat > "$GLAB_CFG" <<GLABEOF
git_protocol: ssh
editor:
browser:
glamour_style: dark
check_update: true
display_hyperlinks: false
host: gitlab.com
no_prompt: false
telemetry: true
hosts:
    gitlab.com:
        api_protocol: https
        api_host: gitlab.com
        token:
        container_registry_domains: gitlab.com,gitlab.com:443,registry.gitlab.com
        custom_headers: []
    $GITLAB_HOST:
        token: $(cat ${config.sops.secrets.glab_token.path})
        container_registry_domains: $GITLAB_HOST,$GITLAB_HOST:443,registry.$GITLAB_HOST
        api_host: $GITLAB_HOST
        git_protocol: https
        api_protocol: https
        user: Gabriel.Morin
GLABEOF
    chown ${primaryUser} "$GLAB_CFG"
    chmod 600 "$GLAB_CFG"

    # Claude Code MCP server configs (Jira + glab)
    CLAUDE_JSON="${home}/.claude.json"
    if [ -f "$CLAUDE_JSON" ] && command -v jq &>/dev/null; then
      JIRA_TOKEN="$(cat ${config.sops.secrets.jira_mcp_token.path})"
      JIRA_URL="$(cat ${config.sops.secrets.jira_mcp_url.path})"
      jq --arg token "$JIRA_TOKEN" --arg url "$JIRA_URL" \
        '.mcpServers.jira = {"type": "http", "url": $url, "headers": {"Authorization": $token}}
         | .mcpServers.glab = {"type": "stdio", "command": "glab", "args": ["mcp", "serve"]}' \
        "$CLAUDE_JSON" > "$CLAUDE_JSON.tmp" && mv "$CLAUDE_JSON.tmp" "$CLAUDE_JSON"
      chown ${primaryUser} "$CLAUDE_JSON"
    fi

    if command -v npm &>/dev/null; then
      npm config set @ticketmaster:registry="$(cat ${config.sops.secrets.npm_ticketmaster_registry.path})"
      npm config set @tm1:registry="$(cat ${config.sops.secrets.npm_tm1_registry.path})"
    fi
  '';
}
