#CA Certificate

[![Build Status](https://travis-ci.org/spjmurray/puppet-ca_certificate.png?branch=master)](https://travis-ci.org/spjmurray/puppet-ca_certificate)

####Table Of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Usage](#usage)
4. [Limitations](#limitations)

##Overview

Installs a CA certificate into OpenSSL's trusted store

###Module Description

Installs distro certificates, installs the requested CA, trusts the certificate
then regenerates the trusted SSL directory.  The CA to install can be a file
resource, raw content, or an existing file on the host.

### Usage

```puppet
ca_certificate { 'puppet-ca':
  source => '/var/lib/puppet/ssl/certs/ca.pem',
}
```
##Limitations

1. Ubuntu only
