{ lib, osConfig ? { }, ... }:

let
  isNiri = lib.attrByPath [ "profiles" "desktop" "niri" "enable" ] false osConfig;
in
{
  config = lib.mkIf isNiri {
    xdg.configFile."niri/config.kdl".text = ''
      input {
          keyboard {
              xkb {
                  layout "us,ru"
                  options "grp:alt_shift_toggle"
              }
          }

          touchpad {
              natural-scroll
          }
      }

      layout {
          gaps 12

          default-column-width {
              proportion 0.5
          }

          focus-ring {
              width 4
              active-color "#7fc8ff"
              inactive-color "#505050"
          }
      }

      spawn-at-startup "waybar"
      spawn-at-startup "mako"
      spawn-at-startup "xwayland-satellite"

      prefer-no-csd

      binds {
          Mod+T { spawn "ghostty"; }
          Mod+Return { spawn "ghostty"; }
          Mod+D { spawn "fuzzel"; }

          Mod+Q { close-window; }
          Mod+Shift+E { quit; }

          Mod+Left  { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Up    { focus-window-up; }
          Mod+Down  { focus-window-down; }

          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+K { focus-window-up; }
          Mod+J { focus-window-down; }

          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Right { move-column-right; }
          Mod+Ctrl+Up    { move-window-up; }
          Mod+Ctrl+Down  { move-window-down; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }

          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }

          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }

          Super+Alt+L { spawn "swaylock"; }

          XF86MonBrightnessUp allow-when-locked=true {
              spawn "brightnessctl" "--class=backlight" "set" "+10%";
          }

          XF86MonBrightnessDown allow-when-locked=true {
              spawn "brightnessctl" "--class=backlight" "set" "10%-";
          }

          XF86AudioRaiseVolume allow-when-locked=true {
              spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
          }

          XF86AudioLowerVolume allow-when-locked=true {
              spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          }

          XF86AudioMute allow-when-locked=true {
              spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          }
      }
    '';
  };
}
