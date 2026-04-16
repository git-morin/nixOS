{ pkgs, lib, ... }:
let
  models = [
    "ministral-3:8b"
    "gemma4:31b"
  ];

  pullScript = pkgs.writeShellScript "ollama-pull-models" ''
    # Wait for ollama server to be ready (up to 60s)
    for i in $(seq 1 30); do
      if ${pkgs.ollama}/bin/ollama list &>/dev/null; then
        break
      fi
      sleep 2
    done

    ${lib.concatMapStringsSep "\n" (model: ''
      echo "Pulling model: ${model}"
      ${pkgs.ollama}/bin/ollama pull ${model}
    '') models}
  '';
in
{
  environment.systemPackages = [ pkgs.ollama ];
  launchd.user.agents.ollama = {
    serviceConfig = {
      ProgramArguments = [ "${pkgs.ollama}/bin/ollama" "serve" ];
      EnvironmentVariables = {
        OLLAMA_HOST = "0.0.0.0";
      };
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/ollama.log";
      StandardErrorPath = "/tmp/ollama.log";
    };
  };

  launchd.user.agents.ollama-pull-models = {
    serviceConfig = {
      ProgramArguments = [ "${pkgs.bash}/bin/bash" "${pullScript}" ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/tmp/ollama-pull.log";
      StandardErrorPath = "/tmp/ollama-pull.log";
    };
  };
}
