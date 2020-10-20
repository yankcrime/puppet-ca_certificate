# == Class: ca_certificate::service
#
# Update the SSL trusted CA certificates
#
class ca_certificate::service {

  exec { 'dpkg-reconfigure ca-certificates':
    unless      => '/bin/ls /etc/ssl/certs/puppet-ca.crt',
    refreshonly => true,
  }

}
