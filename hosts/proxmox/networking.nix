{
  networking = {
      hostName = "ml30";
      interfaces = {
        eno1.useDHCP = false;
        eno2.useDHCP = false;
        ens2f0.useDHCP = false;
        ens2f1.useDHCP = false;
        vmbr0 = {
          ipv4.addresses = [
            {
              address = "192.168.2.55";
              prefixLength = 24;
            }
          ];
        };
      };
      defaultGateway = "192.168.2.1";
      bridges = {
        vmbr0 = {
          interfaces = [ "eno1" ];
          rstp = false;
        };
      };
    };
}
