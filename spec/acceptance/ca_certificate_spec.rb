require 'spec_helper_acceptance'

describe 'ca_certificate' do
  context 'local sync' do
    it 'provisions with no errors' do
      # Generate CA certificate
      shell('puppet cert generate `facter fqdn`')
      # Check for clean provisioning and idempotency
      pp = <<-EOS
        Exec {
          path => '/bin:/usr/bin:/sbin:/usr/sbin',
        }
        ca_certificate { 'puppet-ca':
          source => '/var/lib/puppet/ssl/certs/ca.pem',
          java   => true,
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
    it 'installs openssl puppet CA cert' do
      shell('ls /etc/ssl/certs/puppet-ca.pem', :acceptable_exit_codes => 0)
    end
    it 'installs java puppet CA cert' do
      shell('keytool -list -keystore /etc/ssl/certs/java/cacerts -storepass changeit | grep puppet:puppet-ca.pem', :acceptable_exit_codes => 0)
    end
  end
end
