{
  virtualisation.proxmox.storage = {
      "directory" = {
        type = "dir";
        content = [
          "images"
          "iso"
          "vztmpl"
          "backup"
          "snippets"
        ];
      };

      "local" = {
        type = "dir";
        content = [
          "iso"
          "vztmpl"
          "backup"
          "snippets"
        ];
      };

      "local-lvm" = {
        type = "lvmthin";
        content = [
         "images"
         "rootdir"
        ];
      };

      "lvm-thin" = {
        type = "lvmthin";
        content = [
        "images"
        "rootdir"
        ];
      };
    };
}