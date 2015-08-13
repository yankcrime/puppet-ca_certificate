# == Class: ca_certificate::install
#
# Installs the requisite packages
#
class ca_certificate::install {

  assert_private()

  ensure_packages('ca-certificates')

}
