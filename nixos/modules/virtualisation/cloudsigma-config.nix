{ config, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/cloudconfig-image.nix" ];
}
