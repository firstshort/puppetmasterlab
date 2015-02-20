
## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
filebucket { 'main':
  server => 'learn.localdomain',
  path   => false,
}

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}
node 'agent1.localdomain' {
  include apache
  include sudo

  class {'ntp':
    servers => [ "ntp1.example.com dynamic", "ntp2.example.com dynamic", ],
  }
}

# imported all below as a test 
# /root/examples/file-2.pp
# http://docs.puppetlabs.com/learning/manifests.html#once-more-with-feeling

file {'/tmp/test1':
  ensure  => file,
  content => "Hi.ported all below as a test",
}

file {'/tmp/test2':
  ensure => directory,
  mode   => 0644,
}

file {'/tmp/test3':
  ensure => link,
  target => '/tmp/test1',
}

user {'rachi':
  ensure => absent,
}

notify {"/etc/puppetlabs/puppet/manifests/site.pp I'm notifying you.":}
notify {"So am I!":}

# /root/examples/break_ssh.pp
package { 'openssh-server':
    ensure   => present,
      before => File['/etc/ssh/sshd_config'],
}
file { '/etc/ssh/sshd_config':
    ensure     => file,
      mode     => 600,
        source => '/root/examples/sshd_config',
}
service { 'sshd':
    ensure        => running,
      enable      => true,
        subscribe => File['/etc/ssh/sshd_config'],
}

