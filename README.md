# starter-template

A language-agnostic GitHub template repository with a reproducible, zero-step
development environment. Click **Use this template** to start a new project from it.

## What you get

| Tool | Role | Config |
| --- | --- | --- |
| [Nix flake](https://nixos.wiki/wiki/Flakes) | Pins the exact dev toolchain so everyone (and CI) uses identical versions | [`flake.nix`](flake.nix) |
| [direnv](https://direnv.net/) | Auto-enters the Nix dev shell when you `cd` into the repo | [`.envrc`](.envrc) |
| [lefthook](https://github.com/evilmartians/lefthook) | Installs git hooks automatically on dev-shell entry | [`lefthook.yml`](lefthook.yml) |
| [gitleaks](https://github.com/gitleaks/gitleaks) | Blocks secrets at commit time and re-scans in CI | [`.gitleaks.toml`](.gitleaks.toml) |
| [pinact](https://github.com/suzuki-shunsuke/pinact) | Keeps GitHub Actions pinned to immutable commit SHAs | [`.pinact.yaml`](.pinact.yaml) |

## Getting started

Prerequisites: [Nix with flakes enabled](https://nixos.org/download) and
[direnv](https://direnv.net/docs/installation.html) (hooked into your shell).

```sh
git clone <your-new-repo>
cd <your-new-repo>
direnv allow      # builds the dev shell and installs git hooks
```

That's it. On entry, the dev shell puts `gitleaks`, `pinact`, and `lefthook` on
your `PATH` and runs `lefthook install`, so the gitleaks pre-commit hook is wired
up without any extra steps.

> Editing `flake.nix` or `flake.lock`? `.envrc` watches them and direnv reloads
> the shell automatically.

## How it works

- **Commit-time secret scanning** — [`lefthook.yml`](lefthook.yml) runs
  `gitleaks git --staged` on every commit; a detected secret blocks it.
- **CI defense in depth** — [`.github/workflows/gitleaks.yml`](.github/workflows/gitleaks.yml)
  re-scans on push and PR, catching anything that bypassed local hooks.
- **Action pinning** — [`.github/workflows/pinact.yml`](.github/workflows/pinact.yml)
  fails a PR if any GitHub Action isn't pinned to a commit SHA. Run `pinact run`
  locally to pin them.

## Manual fallback (no direnv)

```sh
nix develop          # enter the dev shell manually
lefthook install     # install git hooks (the shellHook does this for you)
gitleaks git --staged --redact   # scan staged changes
pinact run           # pin GitHub Actions to commit SHAs
```

## Customizing

- Add language toolchains (Node, Go, Rust, …) to `packages` in [`flake.nix`](flake.nix).
- Add git hooks (formatters, linters, commit-msg checks) in [`lefthook.yml`](lefthook.yml).
- Tune secret rules / allowlists in [`.gitleaks.toml`](.gitleaks.toml).
