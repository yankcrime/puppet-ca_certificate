# == Class: ca_certificate::install_java
#
# Installs the requisite packages
#
class ca_certificate::install_java {

  assert_private()

  ensure_packages('ca-certificates-java')

}
