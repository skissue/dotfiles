{
  lib,
  pkgs,
  ...
}: {
  services.llama-swap = {
    enable = true;
    port = 11434;
    settings = {
      # Give adequate time to auto-download models.
      healthCheckTimeout = 500;
      macros = {
        "server" = "${lib.getExe' pkgs.llama-cpp "llama-server"} --port \${PORT} --ctx-size 8192 -fa on --jinja --no-webui";
      };
      models = {
        "qwen3-vl:8b" = {
          cmd = "\${server} -hf unsloth/Qwen3-VL-8B-Thinking-GGUF:Q8_K_XL --temp 1.0 --top-k 20 --top-p 0.95 --presence-penalty 0.0";
          ttl = 120;
        };
        "qwen3-vl:8b-instruct" = {
          cmd = "\${server} -hf unsloth/Qwen3-VL-8B-Instruct-GGUF:Q8_K_XL --temp 0.7 --top-k 20 --top-p 0.8 --presence-penalty 1.5";
          ttl = 120;
        };
        "qwen3:14b" = {
          cmd = "\${server} -hf unsloth/Qwen3-14B-GGUF:UD-Q6_K_XL --temp 0.6 --top-k 20 --top-p 0.95 --min-p 0 --presence-penalty 1.5";
          ttl = 120;
        };
        "qwen3:30b" = {
          cmd = "\${server} -hf unsloth/Qwen3-30B-A3B-Thinking-2507-GGUF:UD-IQ3_XXS --temp 0.6 --top-k 20 --top-p 0.95 --min-p 0 --presence-penalty 1.0";
          ttl = 120;
        };
        "qwen3:30b-instruct" = {
          cmd = "\${server} -hf unsloth/Qwen3-30B-A3B-Instruct-2507-GGUF:UD-IQ3_XXS --temp 0.7 --top-k 20 --top-p 0.8 --min-p 0 --presence-penalty 1.0";
          ttl = 120;
        };
        "qwen3-coder:30b" = {
          cmd = "\${server} -hf unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:UD-IQ3_XXS --temp 0.7 --top-k 20 --top-p 0.8 --presence-penalty 1.05";
          ttl = 120;
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
