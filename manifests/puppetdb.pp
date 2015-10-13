class puppetdb_shared_cert::puppetdb (
  $certname = $puppetdb_shared_cert::certname,
) inherits puppetdb_shared_cert {

  validate_string($certname)

  unless $::settings::ca_server == $::settings::certname {
    fail('puppetdb_shared_cert::puppetdb only functions when compiled on the CA master. It cannot be used in a run against a compile master.')
  }

  file { 'puppetdb-shared-certificate':
    ensure  => file,
    content => file("/etc/puppetlabs/puppet/ssl/certs/${certname}.pem"),
    path    => "/etc/puppetlabs/puppet/ssl/certs/${certname}.pem",
    mode    => '0644',
    owner   => 'pe-puppet',
    group   => 'pe-puppet'
  }
  file { 'puppetdb-shared-publickey':
    ensure  => file,
    content => file("/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem"),
    path    => "/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem",
    mode    => '0644',
    owner   => 'pe-puppet',
    group   => 'pe-puppet'
  }
  file { 'puppetdb-shared-privatekey':
    ensure  => file,
    content => file("/etc/puppetlabs/puppet/ssl/public_keys/${certname}.pem"),
    path    => "/etc/puppetlabs/puppet/ssl/public_keys/${certname}.pem",
    mode    => '0644',
    owner   => 'pe-puppet',
    group   => 'pe-puppet'
  }

  Class['puppetdb_shared_cert::puppetdb'] -> Puppet_enterprise::Certs['pe-puppetdb']
}

