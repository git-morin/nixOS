{ pkgs, ...}:
{
#     virtualization.proxmox.vms = {
#        "100" = {
#          enable = true;
#          name = "satellite";
#          memory = 15800;
#          cores = 4;
#          cpu = "host";
#          boot = {
#            order = "scsi0;ide2";
#            bios = "ovmf";
#          };
#          machine = "q35";
#          ostype = "l26";
#          disks = {
#            efidisk0 = {
#              file = "lvm-thin:vm-100-disk-0";
#              size = "128K";
#            };
#            scsi0 = {
#              file = "lvm-thin:vm-100-disk-1";
#              size = "104960M";
#              discard = "on";
#              ssd = true;
#            };
#            ide2 = {
#              file = "lvm-thin:vm-100-cloudinit";
#              media = "cdrom";
#              size = "4M";
#            };
#          };
#          networks = {
#            net0 = {
#              model = "virtio";
#              macaddr = "02:66:E1:F4:DA:A6";
#              bridge = "vmbr0";
#            };
#          };
#          cloudinit = {
#            user = "root";
#            ipconfig0 = "ip=192.168.2.56/24,gw=192.168.2.1";
#            nameserver = "8.8.8.8";
#            searchdomain = "8.8.8.8";
#          };
#          options = {
#            agent = true;
#            localtime = true;
#            tablet = false;
#            tags = "ubuntu";
#            autostart = false;
#          };
#        };
#
#        "102" = {
#          enable = true;
#          name = "luciol-staging";
#          memory = 4096;
#          cores = 2;
#
#          boot = {
#            order = "scsi0";
#            bios = "ovmf";
#          };
#
#          ostype = "l26";
#
#          disks = {
#            efidisk0 = {
#              file = "directory:102/vm-102-disk-0.qcow2";
#              size = "4M";
#              efitype = "4m";
#            };
#            scsi0 = {
#              file = "directory:102/vm-102-disk-1.qcow2";
#              size = "40G";
#            };
#          };
#
#          networks = {
#            net0 = {
#              model = "virtio";
#              macaddr = "02:55:A1:D6:C7:63";
#              bridge = "vmbr0";
#            };
#          };
#
#          options = {
#            agent = true;
#            localtime = true;
#            tablet = false;
#            tags = "community-script";
#            autostart = true;
#            onboot = true;
#          };
#        };
#
#        "103" = {
#          enable = true;
#          name = "eclss";
#          memory = 6096;
#          cores = 2;
#          cpu = "host";
#
#          boot = {
#            order = "scsi0";
#            bios = "ovmf";
#          };
#
#          machine = "q35";
#          ostype = "l26";
#
#          disks = {
#            efidisk0 = {
#              file = "lvm-thin:vm-103-disk-0";
#              size = "4M";
#            };
#            scsi0 = {
#              file = "lvm-thin:vm-103-disk-1";
#              size = "64G";
#              cache = "writethrough";
#              discard = "on";
#              ssd = true;
#            };
#          };
#
#          networks = {
#            net0 = {
#              model = "virtio";
#              macaddr = "02:CA:8D:1A:5A:48";
#              bridge = "vmbr0";
#            };
#          };
#
#          options = {
#            agent = true;
#            localtime = true;
#            tablet = false;
#            tags = "home-assistant";
#            autostart = true;
#            onboot = true;
#          };
#        };
#
#        "105" = {
#          enable = true;
#          name = "jettison";
#          memory = 12696;
#          cores = 4;
#          cpu = "host";
#
#          boot = {
#            order = "scsi0;net0";
#            bios = "ovmf";
#          };
#
#          machine = "pc-q35-8.1";
#          ostype = "win11";
#
#          disks = {
#            efidisk0 = {
#              file = "lvm-thin:vm-105-disk-0";
#              size = "4M";
#              efitype = "4m";
#              preEnrolledKeys = true;
#            };
#            scsi0 = {
#              file = "lvm-thin:vm-105-disk-1";
#              size = "120G";
#              iothread = true;
#            };
#            tpmstate0 = {
#              file = "lvm-thin:vm-105-disk-2";
#              size = "4M";
#              version = "v2.0";
#            };
#          };
#
#          networks = {
#            net0 = {
#              model = "e1000";
#              macaddr = "BC:24:11:94:F6:61";
#              bridge = "vmbr0";
#              firewall = true;
#            };
#          };
#          usb = {
#            usb0 = {
#              host = "2-7";
#            };
#          };
#          options = {
#            agent = true;
#            numa = false;
#            sockets = 1;
#            tags = "windows";
#            autostart = false;
#          };
#        };
#      };
#
#    virtualization.proxmox.containers = {
#        "101" = {
#          enable = true;
#          name = "blackhole";
#          hostname = "blackhole";
#          memory = 512;
#          cores = 2;
#          swap = 512;
#
#          rootfs = {
#            storage = "directory:101/vm-101-disk-0.raw";
#            size = "2G";
#          };
#
#          # Network
#          networks = {
#            net0 = {
#              name = "eth0";
#              bridge = "vmbr0";
#              hwaddr = "BC:24:11:89:BF:71";
#              ip = "dhcp";
#              type = "veth";
#            };
#          };
#
#          options = {
#            arch = "amd64";
#            ostype = "debian";
#            unprivileged = true;
#            onboot = true;
#            autostart = true;
#            features = {
#              keyctl = true;
#              nesting = true;
#            };
#          };
#        };
#
#        "104" = {
#          enable = true;
#          name = "beesness-hive";
#          hostname = "beesness-hive";
#          memory = 4096;
#          cores = 2;
#          swap = 512;
#
#          rootfs = {
#            storage = "lvm-thin:vm-104-disk-0";
#            size = "65G";
#          };
#
#          networks = {
#            net0 = {
#              name = "eth0";
#              bridge = "vmbr0";
#              hwaddr = "BC:24:11:38:AE:E3";
#              ip = "dhcp";
#              type = "veth";
#            };
#          };
#
#          options = {
#            arch = "amd64";
#            ostype = "debian";
#            unprivileged = true;
#            onboot = false;
#            autostart = false;
#            tags = "debian";
#            features = {
#              keyctl = true;
#              nesting = true;
#            };
#          };
#        };
#      };
}