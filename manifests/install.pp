
class phoenix::install ( $hbase_version, $phoenix_version ) {

  $mm = regsubst($hbase_version,'^(\d+)\.(\d+)\.(\d+)$','\1.\2')

  $mirror = lookup( "mirrors.apache.${fqdn_rand(10)}" )
  $checksum = lookup( 'checksums.phoenix' )["${phoenix_version}-HBase-${mm}"]['sha256']


  if ($facts['hbase']['phoenix']['installed'] == true) and ($facts['hbase']['phoenix']['version'] == $phoenix_version) {

    file {"/var/tmp/apache-phoenix-${phoenix_version}-HBase-${mm}-bin.tar.gz":
      ensure => 'absent',
      backup => false,
    }

    file { "/opt/hbase-${hbase_version}/lib/phoenix-${phoenix_version}-HBase-${mm}-server.jar":
      ensure => 'link',
      target => "/opt/apache-phoenix-${phoenix_version}-HBase-${mm}-bin/phoenix-${phoenix_version}-HBase-${mm}-server.jar",
    }

  } else {

    file { "/var/tmp/apache-phoenix-${phoenix_version}-HBase-${mm}-bin.tar.gz":
      ensure         => 'present',
      owner          => 'root',
      group          => 'root',
      mode           => '0644',
      checksum       => 'sha256',
      checksum_value => $checksum,
      backup         => false,
      source         => "http://${mirror}/phoenix/apache-phoenix-${phoenix_version}-HBase-${mm}/bin/apache-phoenix-${phoenix_version}-HBase-${mm}-bin.tar.gz",
      notify         => Exec["untar phoenix-${phoenix_version}"],
    }

    exec { "untar phoenix-${phoenix_version}":
      command     => "/bin/tar xf /var/tmp/apache-phoenix-${phoenix_version}-HBase-${mm}-bin.tar.gz",
      cwd         => '/opt',
      refreshonly => true,
      require     => File["/var/tmp/apache-phoenix-${phoenix_version}-HBase-${mm}-bin.tar.gz"],
      notify      => Exec['rm phoenix-server.jar'],
    } ->

    exec { 'rm phoenix-server.jar':
      command     => "/bin/rm -f /opt/hbase-${hbase_version}/lib/phoenix-*-server.jar",
      refreshonly => true,
      notify      => Exec["chown phoenix-${phoenix_version}"],
    } ->

    exec { "chown phoenix-${phoenix_version}":
      command     => "/bin/chown -R root:root /opt/apache-phoenix-${phoenix_version}-HBase-${mm}-bin",
      cwd         => '/opt',
      refreshonly => true,
      require     => File["/var/tmp/apache-phoenix-${phoenix_version}-HBase-${mm}-bin.tar.gz"],
    } ->

    file { "/opt/phoenix-${phoenix_version}":
      ensure  => 'link',
      target  => "/opt/apache-phoenix-${phoenix_version}-HBase-${mm}-bin",
      require => File["/var/tmp/apache-phoenix-${phoenix_version}-HBase-${mm}-bin.tar.gz"],
    } ->

    file { '/opt/phoenix':
      ensure  => 'link',
      target  => "/opt/apache-phoenix-${phoenix_version}-HBase-${mm}-bin",
      require => File["/var/tmp/apache-phoenix-${phoenix_version}-HBase-${mm}-bin.tar.gz"],
    }

  }

}
