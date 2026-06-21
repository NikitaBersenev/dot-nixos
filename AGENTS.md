# AGENTS.md

## Repository notes

- Main NixOS flake: `flake.nix`.
- Lenovo host config: `hosts/lenovo/configuration.nix`.
- Lenovo installer ISO config: `hosts/lenovo/installer-iso.nix`.
- Build the Lenovo installer ISO with:

  ```bash
  make lenovo-iso
  ```

- The generated ISO is copied to:

  ```text
  dist/nixos-lenovo-niri-installer.iso
  ```

## Lenovo target hardware

The `lenovo` host targets a laptop with:

- CPU: AMD Ryzen 7 7840H
- GPU: Radeon 780M integrated graphics
- Architecture: x86_64-linux
- Boot mode: UEFI via systemd-boot

The installer script expects to create two partitions and labels:

- `BOOT` for the EFI system partition mounted at `/boot`
- `nixos` for the root ext4 partition mounted at `/`

## Safety rule

Do not merge `feature/NIX-1` into `main` unless the repository owner explicitly approves it.
