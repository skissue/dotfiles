{
  lib,
  pkgs,
  ...
}: {
  services.llama-swap = {
    enable = true;
    port = 11434;
    settings = {
      macros = {
        "server" = "${lib.getExe' pkgs.llama-cpp "llama-server"} --port \${PORT} --no-webui";
      };
      models = {
        "qwen3:14b" = {
          cmd = "\${server} -hf Qwen/Qwen3-14B-GGUF:Q6_K";
        };
      };
    };
  };

  # To have llama.cpp auto-download models from HuggingFace, it needs a writable
  # directory (and needs to be told where it is).
  systemd.services.llama-swap = {
    environment."LLAMA_CACHE" = "%C/llama-swap";
    serviceConfig.CacheDirectory = "llama-swap";
  };
}
