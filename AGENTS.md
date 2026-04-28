# AGENTS.md

## Build Commands
- `just switch` — Build and switch to new NixOS configuration (`nh os switch`)
- `just test` — Build and test configuration without switching (`nh os test`)
- `just boot` — Build and activate on next boot
- `just update` — Update flake inputs and nvfetcher sources
- Formatter: `nix fmt` (uses **alejandra**)

## Architecture
NixOS flake-parts dotfiles repo. Single system architecture: `x86_64-linux`.
- `flake.nix` — Entry point; defines inputs, overlay, devshells, formatter
- `hosts/` — Per-host NixOS configs (iridescent, nightcrawler, prowler, windstorm); each has `default.nix` + `hardware-configuration.nix`
- `system/` — Shared NixOS modules (common, desktop, networking, impermanence, caddy, etc.)
- `home/` — Home Manager modules (emacs, git, cli, niri, eww, ghostty, etc.), imported via `home/default.nix`
- `packages/` — Custom package derivations, exposed as `pkgs.my.<name>` via overlay
- `secrets/` — sops-nix encrypted secrets (`.sops.yaml` at root)
- `_sources/` — nvfetcher-managed upstream sources (`nvfetcher.toml`)
- `hosts/default.nix` — Auto-discovers hosts; sets up deploy-rs nodes

## Code Style
- **Language**: Nix (functional, declarative)
- **Formatter**: alejandra (run `nix fmt`); no trailing commas, no semicolons after `in`
- **Conventions**: Use `inputs` / `self` via specialArgs; helper `mkModulesList` converts module names to paths
- **Imports**: List subdirectory paths in `imports = [ ./subdir ]`; prefer one module per directory with `default.nix`
- **Secrets**: Managed with sops-nix; keys in `.sops.yaml`

## Commit Messages
Conventional commits: `type(scope): lowercase description` (no period). Types: `feat`, `fix`, `refactor`, `bump`. Scope is the module path (e.g., `home/emacs`, `packages/zen-browser`, `system/desktop`). Use `flake` or `sources` for input/nvfetcher bumps. Examples: `feat(home/ghostty): notify on command finish`, `bump(packages/zen-browser): v1.19.10b`.
