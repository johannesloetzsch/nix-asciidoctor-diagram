{ pkgs ? import <nixpkgs> {}
}: 

pkgs.mkShell {
  buildInputs = with pkgs; [ asciidoctor
                             ruby  ## for asciidoctor-diagrams
                             nwdiag python37Packages.setuptools
                             plantuml graphviz ];

  ## needed for mermaid
  ## https://github.com/justinwoo/puppeteer-node2nix 
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "1";
  PUPPETEER_EXECUTABLE_PATH = "${pkgs.chromium.outPath}/bin/chromium";

  shellHook = ''
    npm install @mermaid-js/mermaid-cli  ## TODO install via a nix-package

    asciidoctor -r asciidoctor-diagram -a dot=$(which dot) *.asciidoc *.adoc
    asciidoctor-pdf -r asciidoctor-diagram -a dot=$(which dot) *.asciidoc *.adoc

    exit
  '';
}
