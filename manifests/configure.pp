# == Class: ca_certificate::configure
#
# Installs the pre-requisite directory structures
#
class ca_certificate::configure {

  file { '/usr/share/ca-certificates/puppet':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
