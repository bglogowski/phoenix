class phoenix (
    String $hbase_version,
    String $phoenix_version
  ) {

  class { 'phoenix::install':
    hbase_version   => $hbase_version,
    phoenix_version => $phoenix_version,
    require         => Class['::hbase'],
  }

}
