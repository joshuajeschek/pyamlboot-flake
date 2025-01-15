{
  description = "Nix flake to build pyamlboot from GitHub";

  inputs = {
    # You can change the nixpkgs URL or pin it to a specific revision
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    lib = pkgs.lib;
  in
  {
    # By default, expose the package under `nix build .#pyamlboot`
    packages.${system}.default = pkgs.python3Packages.buildPythonPackage {
      pname = "pyamlboot";
      version = "unstable-2025-01-15";

      # Fetch the latest master (or use a pinned commit for reproducibility).
      # Change "rev" as needed, or use "ref" if you want a particular branch.
      src = pkgs.fetchFromGitHub {
        owner  = "superna9999";
        repo   = "pyamlboot";
        rev    = "master";
        sha256 = "sha256-wN+9QBZ2rgI9CWHhf30MNjfDPuer+CpG4cnSRWY6jQA=";
      };

      # If pyamlboot has runtime dependencies, list them here:
      propagatedBuildInputs = with pkgs.python3Packages; [
        docopt
        intelhex
        pyserial
        pyusb
        setuptools
      ];

      # In case the package doesn’t have tests or they’re broken, disable them:
      doCheck = false;
    };

    # Provide a default so you can do `nix build` or `nix run` on this flake
    defaultPackage.${system} = self.packages.${system}.default;

    # A development shell if you want a Python environment with pyamlboot installed:
    devShell.${system} = pkgs.mkShell {
      buildInputs = [
        self.packages.${system}.default
      ];
    };
  };
}
