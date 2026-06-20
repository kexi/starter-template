{
  description = "Starter template: nix develop + direnv + lefthook + gitleaks + pinact";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            git
            lefthook
            gitleaks
            pinact
          ];

          # Wire up git hooks on every devShell entry. lefthook install is
          # idempotent, so re-running it on each entry keeps .git/hooks in sync
          # with lefthook.yml without a manual setup step after clone.
          shellHook = ''
            if [ -d .git ]; then
              lefthook install >/dev/null 2>&1 || true
            fi
          '';
        };

        formatter = pkgs.nixfmt;
      }
    );
}
