# https://github.com/openai/gym-http-api
# nix-shell --run "python gym_http_server.py"

with import <nixpkgs> {};

(pkgs.python3.withPackages(ps: [ 
  ps.flask
  ps.gym
])).env

