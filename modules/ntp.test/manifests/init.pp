class ntp($servers = undef ) {
case $operatingsystem {
  centos, redhat: {
    $service_name = 'ntpd'
    $conf_file    = 'ntp.conf.el'
    $default_servers = [ "0.centos.pool.ntp.ort",
                         "1.centos.pool.ntp.ort",
                         "2.centos.pool.ntp.ort", ]
  }

  debian, ubuntu: {
    $service_name = 'ntp'
    $conf_file    = 'ntp.conf.debian'
    $default_servers = [ "0.debian.pool.ntp.ort",
                         "1.debian.pool.ntp.ort",
                         "2.debian.pool.ntp.ort",
                         "3.debian.pool.ntp.ort", ]
  }
}

if $servers == undef {
  $servers_real = $default_servers
}
else { 
  $servers_real = $servers
}

package { 'ntp':
  ensure => installed,
}
file { 'ntp.conf':
  path    => '/etc/ntp.conf',
  ensure  => file,
  require => Package['ntp'],
  content  => template("ntp/${conf_file}.erb"),
  #source  => "puppet:///modules/ntp/${conf_file}",
}
service { 'ntp':
  name      => $service_name,
  ensure    => running,
  enable    => true,
  subscribe => File['ntp.conf'],
}
}
