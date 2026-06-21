.PHONY: lenovo-iso lenovo-system check clean

ISO_OUT := dist/nixos-lenovo-niri-installer.iso

lenovo-system:
	nix build .#nixosConfigurations.lenovo.config.system.build.toplevel

lenovo-iso:
	nix build .#nixosConfigurations.lenovo-installer.config.system.build.isoImage
	mkdir -p dist
	cp -fL result/iso/*.iso $(ISO_OUT)
	@echo ""
	@echo "ISO written to $(ISO_OUT)"
	@echo "Boot it on the Lenovo laptop, then run:"
	@echo "  sudo install-lenovo /dev/nvme0n1 --yes"

check:
	nix flake check

clean:
	rm -rf result dist
