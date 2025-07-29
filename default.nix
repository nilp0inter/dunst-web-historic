{ stdenv, writeShellApplication, kapowbang, dunst, jq, coreutils, runtimeShell }:

let
  pname = "dunst-web-historic";
  version = "0.1.0";

  # A simple derivation to hold our application files
  app = stdenv.mkDerivation {
    name = "dunst-web-historic-src";
    src = ./.;
    installPhase = ''
      mkdir -p $out
      cp ${./dunst_kapow_script.sh} $out/dunst_kapow_script.sh
      cp ${./index.html} $out/index.html
      chmod +x $out/dunst_kapow_script.sh
    '';
  };

in
# The main package using writeShellApplication
writeShellApplication {
  name = pname;

  # Add all necessary runtime dependencies to the PATH
  runtimeInputs = [ kapowbang dunst jq coreutils ];

  # The script content that will be executed by `nix run`
  text = ''
    #!${runtimeShell}
    # Change to the directory containing our script and html file
    cd ${app}
    # Execute kapow, which is now in the PATH.
    # The dunst_kapow_script.sh will find the index.html in its CWD.
    kapow server --bind 127.0.0.1:9888 ./dunst_kapow_script.sh "$@"
  '';
}