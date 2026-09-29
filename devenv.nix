{
  pkgs,
  ...
}:
{

  packages = with pkgs; [
    git
    wrangler
    just
    just-lsp
    poppler-utils # pdftotext
  ];

  languages = {
    typst.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
