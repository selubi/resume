{
  pkgs,
  ...
}:
{

  packages = with pkgs; [
    git
    wrangler
    bash
    gnumake
    mbake
    poppler-utils # pdftotext
    noto-fonts-cjk-sans
    source-sans
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
