{pkgs, ...}: {
  services.mpd = {
    enable = true;
    musicDirectory = "/home/ad/BigBoiStorage/theuniverse/libraries/music";
    extraConfig = ''
      audio_output {
        type       "pipewire"
        name       "PipeWire Sound Server"
        # Fixes mpd setting global volume for some reason
        mixer_type "software"
      }

      # For visualization in ncmpcpp
      audio_output {
        type        "fifo"
        name        "fifo"
        path        "/tmp/mpd.fifo"
        format      "44100:16:2"
        buffer_time "100000"
      }
    '';
  };

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {visualizerSupport = true;};
    settings = {
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
    };
  };
  home.packages = with pkgs; [mpc-cli mpd-mpris];
}
