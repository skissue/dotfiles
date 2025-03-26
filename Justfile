alias u := update

# Build and switch to a new configuration.
switch:
    nh os switch --no-specialisation --ask

# Build and test a new configuration.
test:
    nh os test --specialisation mutable-links --ask

# Build a new configuration and activate it next boot.
boot:
    nh os boot

# Update flake inputs and nvfetcher.
update *inputs:
    nix flake update --commit-lock-file --option commit-lockfile-summary 'bump(flake): update inputs' {{inputs}}
    nvfetcher
    git add _sources
    -git commit -m 'bump: update nvfetcher sources'
