{ lib, config, pkgs, ... }:

let
  cfg = config.profiles.desktop.niri;

  kde = lib.attrByPath [ "profiles" "desktop" "kde" "enable" ] false config;
  gnome = lib.attrByPath [ "profiles" "desktop" "gnome" "enable" ] false config;
  hyprland = lib.attrByPath [ "profiles" "desktop" "hyprland" "enable" ] false config;
in
{
  options.profiles.desktop.niri = {
    enable = lib.mkEnableOption "Niri Wayland compositor";

    wayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run SDDM on Wayland.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (!kde) && (!gnome) && (!hyprland);
        message = "Включите только один desktop/WM: niri, kde, gnome или hyprland.";
      }
    ];

    programs.niri.enable = true;

    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = lib.mkDefault cfg.wayland;

    services.displayManager.gdm.enable = lib.mkForce false;
    services.xserver.displayManager.gdm.enable = lib.mkForce false;
    services.desktopManager.gnome.enable = lib.mkForce false;
    services.xserver.desktopManager.gnome.enable = lib.mkForce false;
    services.desktopManager.plasma6.enable = lib.mkForce false;

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    hardware.graphics.enable = true;

    xdg.portal.enable = true;
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    xdg.portal.config.common.default = [ "gtk" ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
      niri
      xwayland-satellite
      ghostty
      alacritty
      fuzzel
      waybar
      mako
      swayidle
      swaylock
      swww
      wl-clipboard
      brightnessctl
      playerctl
      grim
      slurp
    ];
  };
}
