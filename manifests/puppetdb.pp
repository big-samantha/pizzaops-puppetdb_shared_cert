class puppetdb_shared_cert::puppetdb (
  $certname  = $puppetdb_shared_cert::certname,
  $key_owner = 'root',
  $key_group = '0',
) inherits puppetdb_shared_cert {

  validate_string($certname)
  validate_string($key_owner)
  validate_string($key_group)

  unless $::settings::ca_server == $::settings::certname {
    fail('puppetdb_shared_cert::puppetdb only functions when compiled on the CA master. It cannot be used in a run against a compile master.')
  }

  file { 'puppetdb-shared-certificate':
    ensure  => file,
    content => file("/etc/puppetlabs/puppet/ssl/certs/${certname}.pem"),
    path    => "/etc/puppetlabs/puppet/ssl/certs/${certname}.pem",
    mode    => '0644',
    owner   => $key_owner,
    group   => $key_group,
  }
  file { 'puppetdb-shared-publickey':
    ensure  => file,
    content => file("/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem"),
    path    => "/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem",
    mode    => '0644',
    owner   => $key_owner,
    group   => $key_group,
  }
  file { 'puppetdb-shared-privatekey':
    ensure  => file,
    content => file("/etc/puppetlabs/puppet/ssl/public_keys/${certname}.pem"),
    path    => "/etc/puppetlabs/puppet/ssl/public_keys/${certname}.pem",
    mode    => '0644',
    owner   => $key_owner,
    group   => $key_group,
  }

  Class['puppetdb_shared_cert::puppetdb'] -> Puppet_enterprise::Certs['pe-puppetdb']
}

