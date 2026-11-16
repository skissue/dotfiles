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
    -git commit -m 'bump(sources): update nvfetcher'

# Update selected Git inputs (all if omitted), then archive releases and dependencies.
[working-directory: 'system/desktop/emacs/lock']
emacs-update *inputs:
    nix flake update {{inputs}}
    nix run --impure --refresh "{{justfile_directory()}}#nixosConfigurations.windstorm.config.system.build.emacs-twist.generateLockDir" -- --force --no-update-flake-lock .
    git add flake.nix flake.lock archive.lock
    git diff --cached --quiet -- flake.nix flake.lock archive.lock || git commit --only -m 'bump(system/desktop/emacs): update packages' -- flake.nix flake.lock archive.lock
