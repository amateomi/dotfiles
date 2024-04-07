{ pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  services = {
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
      };
    };
    gnome.core-utilities.enable = false;
  };

  programs.dconf.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  home-manager.users.amateomi = { lib, ... }: {
    home.packages = with pkgs; [
      gnome.nautilus
      gnome.gnome-tweaks

      gnomeExtensions.another-window-session-manager
      gnomeExtensions.blur-my-shell
      gnomeExtensions.caffeine
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.gnome-40-ui-improvements
      gnomeExtensions.hide-universal-access
      gnomeExtensions.vitals
    ];

    gtk = {
      enable = true;

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };

    dconf = {
      enable = true;

      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";

          enable-hot-corners = false;
          show-battery-percentage = true;

          clock-show-weekday = true;
          clock-show-seconds = true;

          font-name = "Noto Sans 11";
          document-font-name = "Noto Serif 11";
          monospace-font-name = "Noto Sans Mono 10";
          titlebar-font = "Noto Sans Bold 11";
          text-scaling-factor = 1.25;
        };
        "org/gnome/desktop/background" = {
          picture-uri = "file:///etc/nixos/dotfiles/images/background.jpg";
          picture-uri-dark = "file:///etc/nixos/dotfiles/images/background.jpg";
          primary-color = "#000000000000";
          secondary-color = "#000000000000";
        };
        "org/gnome/desktop/screensaver" = {
          picture-uri = "file:///etc/nixos/dotfiles/images/background.jpg";
          primary-color = "#000000000000";
          secondary-color = "#000000000000";
        };
        "org/gnome/desktop/session" = {
          idle-delay = 0;
        };
        "org/gnome/desktop/sound" = {
          event-sounds = false;
        };
        "org/gnome/desktop/input-sources" = {
          sources = [
            (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
            (lib.hm.gvariant.mkTuple [ "xkb" "ru" ])
          ];
        };
        "org/gnome/desktop/peripherals/touchpad" = {
          speed = 0.5;
          tap-to-click = true;
        };
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "close,minimize,maximize:appmenu";
        };

        "org/gnome/settings-daemon/plugins/power" = {
          idle-dim = false;
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
          power-button-action = "interactive";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>t";
          command = "env WAYLAND_DISPLAY= alacritty";
        };

        "org/gnome/mutter" = {
          center-new-windows = true;
        };

        "system/locale" = {
          region = "ru_RU.UTF-8";
        };

        "org/gnome/shell" = {
          last-selected-power-profile = "power-saver";
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "spotify.desktop"
            "discord.desktop"
            "firefox.desktop"
            "org.telegram.desktop.desktop"
            "code.desktop"
          ];
          enabled-extensions = [
            "another-window-session-manager@gmail.com"
            "blur-my-shell@aunetx"
            "caffeine@patapon.info"
            "clipboard-indicator@tudmotu.co"
            "dash-to-dock@micxgx.gmail.com"
            "gnome-ui-tune@itstime.tech"
            "hide-universal-access@akiirui.github.io"
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            "Vitals@CoreCoding.com"
          ];
        };

        "org/gnome/shell/extensions/another-window-session-manager" = {
          enable-restore-previous-session = true;
          show-indicator = false;
          restore-previous-delay = 5;
        };

        "org/gnome/shell/extensions/blur-my-shell/panel" = {
          blur = false;
        };
        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
          blur = false;
        };

        "org/gnome/shell/extensions/caffeine" = {
          user-enabled = true;
          restore-state = true;
          indicator-position-max = 2;
          show-indicator = "never";
        };

        "org/gnome/shell/extensions/clipboard-indicator" = {
          enable-keybindings = false;
        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          dock-position = "BOTTOM";
          multi-monitor = true;
          dash-max-icon-size = 48;
          height-fraction = 0.9;
          show-apps-at-top = true;
          show-trash = false;
          custom-theme-shrink = true;
          custom-background-color = false;
          disable-overview-on-startup = true;
          transparency-mode = "DYNAMIC";
        };

        "org/gnome/shell/extensions/vitals" = {
          network-speed-format = 1;
          hot-sensors = [
            "__temperature_avg__"
            "_processor_usage_"
            "_memory_usage_"
          ];
        };
      };
    };
  };
}
