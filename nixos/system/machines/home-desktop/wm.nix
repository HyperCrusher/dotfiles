{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    flameshot
    xclip
    dunst
  ];
  services.xserver = {
    enable = true;
    windowManager = {
      bspwm = {
        enable = true;
        sxhkd.package = pkgs.sxhkd;
      };
    };
    monitorSection = ''
      VertRefresh     48.0 - 165.0
      Option         "DPMS"
    '';
    screenSection = ''
      Option         "nvidiaXineramaInfoOrder" "DP-4"
      Option         "metamodes" "DP-4: 2560x1440_144 +0+0 {AllowGSYNCCompatible=On}, DP-2: 2560x1440_144 +2560+0 {AllowGSYNCCompatible=On}"
    '';
  };

  services.displayManager.ly.enable = true;
}
