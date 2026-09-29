{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{

  packages = with pkgs; [
    git
    wrangler
    just
    poppler-utils # pdftotext
  ];

  # https://devenv.sh/languages/
  languages = {
    typst.enable = true;
  };

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
