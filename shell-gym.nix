# nix-shell shell-gym.nix 
# gym_http_server

with import <nixpkgs> {};

let
  gym-http-api-src = fetchTarball {
    url = "https://github.com/openai/gym-http-api/archive/15b68c3.tar.gz";
    sha256 = "1zl5s79xy14ghpijy5s7pxjlfgng5hnyh0zbfn24hwhkk8161hwy";
  };

  mypython = pkgs.python3.withPackages(ps: [ 
    ps.flask
    ps.gym
  ]);

in mkShell {
  shellHooks = ''
    alias gym_http_server="${mypython}/bin/python ${gym-http-api-src}/gym_http_server.py"
  '';
}

