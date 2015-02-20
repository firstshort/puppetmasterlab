class site::basic {
      if $osfamily == 'windows' {
        include win_desktop_shortcut
      }
      else {
        include motd
        include core_permissions
      }
    }
