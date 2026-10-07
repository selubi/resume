# devenv.nix
{
  pkgs,
  ...
}:
{
  packages = with pkgs; [
    # Basics
    git
    bash
    gnumake

    # LSP
    mbake

    # Prebuild
    noto-fonts-cjk-sans
    source-sans

    # Lint
    poppler-utils # pdftotext
    harper

    # Deploy
    wrangler
  ];

  languages = {
    typst = {
      enable = true;
      fontPaths = [
        "${pkgs.noto-fonts-cjk-sans}"
        "${pkgs.source-sans}"
      ];
    };
  };
  # See full reference at https://devenv.sh/reference/options/
}
