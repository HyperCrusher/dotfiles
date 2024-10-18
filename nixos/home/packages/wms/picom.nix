{ ... }:
{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    inactiveOpacity = 0.8;
    activeOpacity = 1.0;
    menuOpacity = 0.8;
    opacityRules = [
      "90:class_g = 'discord-screenaudio'"
      "100:name *= 'YouTube'"
      "90:class_g = 'Vivaldi-stable'"
      "90:class_g = 'zen-alpha'"
      "90:name *= 'zsh'"
      "90:name *= 'nix-shell'"
      "90:name *= 'nvim'"
      "90:name *= 'tmux'"
      "90:class_g = 'Emacs'"
    ];

    settings = {
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-client-opacity = true;
      detect-transient = true;
      detect-client-leader = true;
      use-damage = false;

      # Opacity settings
      frame-opacity = 0.8;
      inactive-opacity-override = false;

      # Blur settings
      blur = {
        method = "dual_kawase";
        strength = 3;
        deviation = 1.0;
        background = true;
        background-frame = true;
        background-fixed = false;
        kern = "3x3box";
      };

      blur-background-exclude = [
        "window_type = 'dock'"
      ];
    };
  };
}
