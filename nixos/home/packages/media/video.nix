{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    ani-cli
    tenacity
    kdePackages.kdenlive
    obs-studio
    obs-cli
    obs-studio-plugins.wlrobs
    obs-studio-plugins.waveform
    #obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-webkitgtk
    obs-studio-plugins.obs-mute-filter
    obs-studio-plugins.obs-source-clone
    obs-studio-plugins.obs-pipewire-audio-capture
  ];
}
