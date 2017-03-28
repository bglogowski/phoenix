class phoenix (
    String $hbase_version   = '1.1.9',
    String $phoenix_version = '4.8.2'
  ) {

  class { 'hbase::phoenix::install':
    hbase_version   => $hbase_version,
    phoenix_version => $phoenix_version,
    require         => Class['::hbase'],
  }

}
