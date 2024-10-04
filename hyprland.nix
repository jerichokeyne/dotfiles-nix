{split-monitor-workspaces, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    # systemd.variables = ["--all"];
    plugins = [
      split-monitor-workspaces.packages.x84_64-linux.split-monitor-workspaces
    #   "/home/jericho/GitClones/split-monitor-workspaces"
    ];
    settings = {
      "$mod" = "SUPER";

      monitor = [
        "monitor=eDP-1,1920x1200,0x0,1"
        "monitor=DP-5,1920x1080,1920x0,1"
        "monitor=DP-7,1920x1080,3840x0,1"
        "monitor=,preferred,auto,auto"
      ];

      exec-once = [
        "waybar"
        "nm-applet"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct" # change to qt6ct if you have that
      ];

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "no";
        };
        sensitivity = 0; # -1.0 to 1.0, 0 means no modification
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "master";
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = "yes";        
        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more        
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";        
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "yes"; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        # new_is_master = true;
      };

      gestures = {
        workspace_swipe = "on";
      };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
      };
      # # Example windowrule v1
      # # windowrule = float, ^(kitty)$
      # # Example windowrule v2
      # # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      windowrulev2 = [
        "suppressevent maximize, class:.*" # You'll probably like this.
      ];


      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        # Requires playerctl
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];

      bind =
        [
          "$mod, p, exec, rofi -show drun"
          "$mod, o, exec, rofi-rbw"
          "$mod, W, exec, firefox"
          "$mod, E, exec, dolphin"
          "$mod SHIFT, Return, exec, alacritty"
          ", Print, exec, grimblast copy area"
          "$mod SHIFT, Q, killactive"
          "$mod SHIFT, Escape, exit"
          "$mod SHIFT, Space, togglefloating"
          "$mod, L, exec, hyprlock"

          "$mod, Period, layoutmsg, cyclenext"
          "$mod, Comma, layoutmsg, cycleprev"
          "$mod, Return, layoutmsg, swapwithmaster master"
          "$mod, Equal, layoutmsg, addmaster"
          "$mod, Minus, layoutmsg, removemaster"
          "$mod, X, layoutmsg, orientationnext"
          "$mod, Z, layoutmsg, orientationprev"

          # Move focus with mainMod + arrow keys
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          "CTRL ALT SHIFT, right, movecurrentworkspacetomonitor, r"
          "CTRL ALT SHIFT, left, movecurrentworkspacetomonitor, l"
          "CTRL ALT, right, focusmonitor, r"
          "CTRL ALT, left, focusmonitor, l"

          # "$mod SHIFT, left, split-changemonitor, prev"
          # "$mod SHIFT, right, split-changemonitor, next"

          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mainMod + scroll
          # "$mod, mouse_down, split-workspace, e+1"
          # "$mod, mouse_up, split-workspace, e-1"
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                # "$mod, code:1${toString i}, split-workspace, ${toString ws}"
                # "$mod SHIFT, code:1${toString i}, split-movetoworkspace, ${toString ws}"
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
      };
    };
  };
  # services.clipmenu = {
  #   enable = true;
  #   launcher = "rofi";
  # };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
          "hyprland/scratchpad"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "power-profiles-daemon"
          "cpu"
          "memory"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];
        "hyprland/workspaces" = {
          # format = "{name}: {icon}";
          format = "{icon}";
          on-scroll-up =  "hyprctl dispatch workspace e+1";
          on-scroll-down =  "hyprctl dispatch workspace e-1";
          all-outputs = false;
          # disable-scroll = true;
          # warp-on-scroll = false;
          # format-icons = {
          #     "1" = "";
          #     "2" = "";
          #     "3" = "";
          #     "4" = "";
          #     "5" = "";
          #     "urgent" = "";
          #     "focused" = "";
          #     "default" = "";
          # };
        };
        "hyprland/window" = {
          separate-outputs = true;
        };
  #     "keyboard-state": {
  #         "numlock": true,
  #         "capslock": true,
  #         "format": "{name} {icon}",
  #         "format-icons": {
  #             "locked": "",
  #             "unlocked": ""
  #         }
  #     },
        "hyprland/submap" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "hyprland/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = ["" ""];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };
        idle_inhibitor = {
            format = "{icon}";
            format-icons = {
                activated = "";
                deactivated = "";
            };
        };
        tray = {
          # icon-size = 21;
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval =  1;
          format =  "{:%H:%M:%S}";
          format-alt =  "{:%Y-%m-%d}";
        };
        cpu = {
            format = "{usage}% ";
            tooltip = false;
        };
        memory = {
            format = "{}% ";
        };
        backlight = {
            # device = "acpi_video1";
            format = "{percent}% {icon}";
            format-icons = ["🌑" "🌘" "🌗" "🌖" "🌕"];
        };
        battery = {
            states = {
                # good = 95;
                warning = 30;
                critical = 15;
            };
            format = "{capacity}% {icon}";
            format-full = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            # format-good = ""; # An empty format will hide the module
            # format-full = "";
            format-icons = ["" "" "" "" ""];
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile = {profile}\nDriver = {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
        pulseaudio = {
            # scroll-step = 1; # %; can be a float
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = ["" "" ""];
            };
            on-click = "pavucontrol";
        };
      };
    };
  # systemd.enable = true;
  };

}
