alias u := update

# Build and switch to a new configuration.
switch:
    doas nixos-rebuild switch --fast

# Build and test a new configuration.
test:
    doas nixos-rebuild test --fast

# Build a new configuration and activate it next boot.
boot:
    doas nixos-rebuild boot

# Update flake inputs and nvfetcher.
update *inputs:
    nix flake update --commit-lock-file --option commit-lockfile-summary 'bump(flake): update inputs' {{inputs}}
    nvfetcher
    git add _sources
    -git commit -m 'bump: update nvfetcher sources'
