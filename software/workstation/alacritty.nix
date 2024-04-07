{
  imports = [ <home-manager/nixos> ];

  home-manager.users.amateomi = { lib, ... }: {
    programs.alacritty = {
      enable = true;

      settings = {
        env.TERM = "xterm-256color";

        window = {
          dimensions = {
            columns = 120;
            lines = 30;
          };
          padding = {
            x = 0;
            y = 0;
          };
          dynamic_padding = false;
          decorations = "full";

          opacity = 0.8;

          startup_mode = "Windowed";

          title = "Alacritty";
          dynamic_title = true;

          class = {
            instance = "Alacritty";
            general = "Alacritty";
          };
        };

        scrolling = {
          history = 10000;
          multiplier = 3;
        };

        font = {
          normal = {
            family = "JetBrains Mono";
            style = "Regular";
          };
          bold = {
            family = "JetBrains Mono";
            style = "Bold";
          };
          italic = {
            family = "JetBrains Mono";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrains Mono";
            style = "Bold Italic";
          };

          size = 11.0;

          offset = {
            x = 0;
            y = 0;
          };
          glyph_offset = {
            x = 0;
            y = 0;
          };

          builtin_box_drawing = true;
        };

        draw_bold_text_with_bright_colors = true;

        # Tokyo Night theme
        colors = {
          primary = {
            background = "0x1a1b26";
            foreground = "0xa9b1d6";
          };
          normal = {
            black = "0x32344a";
            red = "0xf7768e";
            green = "0x9ece6a";
            yellow = "0xe0af68";
            blue = "0x7aa2f7";
            magenta = "0xad8ee6";
            cyan = "0x449dab";
            white = "0x787c99";
          };
          bright = {
            black = "0x444b6a";
            red = "0xff7a93";
            green = "0xb9f27c";
            yellow = "0xff9e64";
            blue = "0x7da6ff";
            magenta = "0xbb9af7";
            cyan = "0x0db9d7";
            white = "0xacb0d0";
          };
        };

        bell.duration = 0;

        selection = {
          semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
          save_to_clipboard = true;
        };

        cursor = {
          style = {
            shape = "Beam";
            blinking = "Always";
          };
          blink_interval = 750;
          unfocused_hollow = true;
          thickness = 0.15;
        };

        live_config_reload = true;

        working_directory = "None";

        ipc_socket = true;

        mouse = {
          double_click = {
            threshold = 300;
          };
          triple_click = {
            threshold = 300;
          };
          hide_when_typing = false;
        };
      };
    };
  };
}
