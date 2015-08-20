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
# [*java*]
#   Install the certificate into java's trusted CA store
#
# [*java_keystore*]
#   Path to the java key store
#
# [*java_storepass*]
#   Password for java's key store
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
  $java = false,
  $java_keystore = '/etc/ssl/certs/java/cacerts',
  $java_storepass = 'changeit',
) {

  include ::ca_certificate::install
  include ::ca_certificate::configure
  include ::ca_certificate::service

  $cert_path = "/usr/share/ca-certificates/puppet/${name}.crt"

  #
  # Standard OpenSSL Support
  #

  Class['::ca_certificate::install'] ->

  Class['::ca_certificate::configure'] ->

  # Add the certificate to the trusted list so dpkg-reconfigure
  # doesn't black list the certificate
  file_line { "trust_ca_certificate_${name}":
    line    => "puppet/${name}.crt",
    path    => '/etc/ca-certificates.conf',
  } ->

  file { $cert_path:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $source,
    content => $content,
  } ~>

  Class['::ca_certificate::service']

  #
  # Java Support
  #

  if $java {

    include ::ca_certificate::install_java

    $alias = "puppet:${name}.pem"

    $add_command = join([
      'keytool',
      '-import',
      '-noprompt',
      "-file ${cert_path}",
      "-alias ${alias}",
      "-keystore ${java_keystore}",
      "-storepass ${java_storepass}",
    ], ' ')

    $list_command = join([
      'keytool',
      '-list',
      "-keystore ${java_keystore}",
      "-storepass ${java_storepass}",
    ], ' ')

    Class['::ca_certificate::install_java'] ->

    File[$cert_path] ~>

    exec { "ca_certificate java ${alias}":
      command => $add_command,
      unless  => "${list_command} | grep ${alias}",
    }

  }

}
