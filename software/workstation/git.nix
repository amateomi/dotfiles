{
  imports = [ <home-manager/nixos> ];

  home-manager.users.amateomi = { lib, ... }: {
    programs.git = {
      enable = true;
      lfs.enable = true;

      userName = "Andrey Sikorin";
      userEmail = "amaomi.prog@gmail.com";

      extraConfig = {
        init.defaultBranch = "master";
      };
    };
  };
}
