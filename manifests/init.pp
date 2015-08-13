# == Define: ca_certificate
#
# Installs a CA certificate into OpenSSL's trusted directory
# so that software can implicitly verify trust with a remote
# service e.g. 3rd party software like phpIPAM which does
# not offer explicit SSL trust configuration
#
# === Parameters
#
# [*name*]
#   Name to store the certificate as.
#
# [*source*]
#   Certificate source, either an absolute path on the host
#   or a puppet file reference
#
# [*content*]
#   Certificate content
#
# === Usage
#
# Install the puppet CA certificate
#
#    ca_certificate { 'puppet-ca':
#      source => '/var/lib/puppet/ssl/certs/ca.pem',
#    }
#
define ca_certificate (
  $source = undef,
  $content = undef,  
) {

  include ::ca_certificate::install
  include ::ca_certificate::configure
  include ::ca_certificate::service

  Class['::ca_certificate::install'] ->
  Class['::ca_certificate::configure'] ->

  # Add the certificate to the trusted list so dpkg-reconfigure
  # doesn't black list the certificate
  file_line { "trust_ca_certificate_${name}":
    line    => "puppet/${name}.crt",
    path    => '/etc/ca-certificates.conf',
  } ->

  file { "/usr/share/ca-certificates/puppet/${name}.crt":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $source,
    content => $content,
  } ~>

  Class['::ca_certificate::service']

}
