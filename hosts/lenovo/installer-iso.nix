{ pkgs, lib, modulesPath, inputs, ... }:

let
  lenovoSystem = inputs.self.nixosConfigurations.lenovo.config.system.build.toplevel;

  installLenovo = pkgs.writeShellScriptBin "install-lenovo" ''
    set -euo pipefail

    usage() {
      cat <<'USAGE'
Usage:
  sudo install-lenovo /dev/nvme0n1 --yes

This will erase the target disk, create:
  - EFI partition labeled BOOT mounted at /boot
  - ext4 root partition labeled nixos mounted at /

After installation, reboot and select the niri session in SDDM.
USAGE
    }

    disk="''${1:-}"
    confirm="''${2:-}"

    if [ "$disk" = "" ] || [ "$confirm" != "--yes" ]; then
      usage
      exit 1
    fi

    if [ "$(id -u)" != 0 ]; then
      echo "Run as root: sudo install-lenovo $disk --yes"
      exit 1
    fi

    if [ ! -b "$disk" ]; then
      echo "Target disk does not exist: $disk"
      exit 1
    fi

    echo "About to ERASE $disk."
    echo "Press Enter to continue, or Ctrl+C to abort."
    read -r _

    umount -R /mnt 2>/dev/null || true
    swapoff --all 2>/dev/null || true

    parted --script "$disk" -- mklabel gpt
    parted --script "$disk" -- mkpart ESP fat32 1MiB 1025MiB
    parted --script "$disk" -- set 1 esp on
    parted --script "$disk" -- mkpart primary ext4 1025MiB 100%

    partprobe "$disk"
    sleep 2

    if [[ "$disk" == *nvme* || "$disk" == *mmcblk* ]]; then
      boot_part="$disk"p1
      root_part="$disk"p2
    else
      boot_part="$disk"1
      root_part="$disk"2
    fi

    mkfs.fat -F32 -n BOOT "$boot_part"
    mkfs.ext4 -F -L nixos "$root_part"

    mount /dev/disk/by-label/nixos /mnt
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/BOOT /mnt/boot

    nixos-install --system ${lenovoSystem}

    cat <<'DONE'

Lenovo NixOS installation finished.
Before rebooting, set a password if needed:
  nixos-enter --root /mnt -c 'passwd habe'

Then reboot:
  reboot
DONE
  '';
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    installLenovo
    git
    vim
    parted
    gptfdisk
    dosfstools
    e2fsprogs
    util-linux
    pciutils
    usbutils
  ];

  environment.etc."dot-nixos".source = ../..;

  # Include the prebuilt Lenovo system closure in the ISO so the laptop does
  # not need to build the whole system during installation.
  isoImage.storeContents = [
    lenovoSystem
  ];

  isoImage.isoName = lib.mkForce "nixos-lenovo-niri-installer.iso";
}
