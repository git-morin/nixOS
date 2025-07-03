if $nu.is-interactive {
    let s_mem = (sys mem)
    let s_ho = (sys host)
    let s_disks = (sys disks)
    let s_temp = (sys temp)
    let s_net = (sys net)
    let root_disk = ($s_disks | where mount == "/" | get 0? | default ($s_disks.0?))
    let disk_info = if ($root_disk != null) {
        let used = ($root_disk.total - $root_disk.free)
        $"Disk: ($root_disk.mount) ($used) / ($root_disk.total)"
    } else {
        "Disk: N/A"
    }

    let temp_info = if ($s_temp | is-empty) {
        "Temp: N/A"
    } else {
        $"Temp: ($s_temp.0.temp)"
    }
    let net_interface = ($s_net | where name == "enp12s0" | get 0? | default ($s_net.0?))
    let net_info = if ($s_net | is-empty) {
        "Net: N/A"
    } else {
        $"Net: ($net_interface.name) ⬇️ ($net_interface.recv) / ⬆️ ($net_interface.sent)"
    }

    let version = (version | get version)
    let ram_line = $"💾 RAM ($s_mem.used) / ($s_mem.total)"
    let os_line = $"🚀 ($s_ho.long_os_version)"

    let ellie = [
        "     __  ,"
        " .--()°'.'"
        "'|, . ,'  "
        ' !_-(_\\   '
    ]

    print $"(ansi green)($ellie.0)(ansi reset)"
    print $"(ansi green)($ellie.1)(ansi reset)  (ansi yellow)🐚 Nushell v($version)(ansi reset)       || (ansi white)🖴 ($disk_info)(ansi reset)"
    print $"(ansi green)($ellie.2)(ansi reset)  (ansi light_blue)($ram_line)(ansi reset)   ||(ansi red)🌡️ ($temp_info)(ansi reset)"
    print $"(ansi green)($ellie.3)(ansi reset) (ansi light_purple)($os_line)(ansi reset)    || (ansi cyan)🌐 ($net_info)(ansi reset)"
}

let carapace_completer = { |spans| carapace $spans.0 nushell ...$spans | from json }
$env.config = {
  show_banner: false
  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
    external: {
      enable: true
      max_results: 100
      completer: $carapace_completer
    }
  }
}

$env.PATH = ($env.PATH | split row (char esep) | prepend /home/gab/.apps | append /usr/bin/env)