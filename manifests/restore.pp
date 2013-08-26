# Parameters:
#
class dierendeterminatie::restore (
  $version = undef,
  $restore_directory = '/tmp/restore/',
  $bucket = undef,
  $dest_id = undef,
  $dest_key = undef,
  $cloud = undef,
  $pubkey_id = undef,
)
{
  notify {'Restore enabled':}

  package { 'unzip':
    ensure => present,
  }

  duplicity::restore { 'backup':
    directory      => $restore_directory,
    bucket         => $bucket,
    dest_id        => $dest_id,
    dest_key       => $dest_key,
    cloud          => $cloud,
    pubkey_id      => $pubkey_id,
    post_command   => '/usr/local/sbin/configrestore.sh && /usr/local/sbin/mysqlrestore.sh',
  }

  file { "/usr/local/sbin/configrestore.sh":
    content => template('dierendeterminatie/configrestore.sh.erb'),
    mode    => '0755',
  }

  exec { 'duplicityrestore.sh':
    require => File['/usr/local/sbin/duplicityrestore.sh','/usr/local/sbin/configrestore.sh','/usr/local/sbin/mysqlrestore.sh'],
    command => '/bin/bash /usr/local/sbin/duplicityrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
  }

  exec { 'mysqlrestore.sh':
    require => Exec['duplicityrestore.sh'],
#    require => File['/tmp/restore/mysql_backup.sql.bz2','/usr/local/sbin/configrestore.sh','/usr/local/sbin/mysqlrestore.sh'],
    command => '/bin/bash /usr/local/sbin/mysqlrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
  }

  exec { 'configrestore.sh':
    require => Exec['duplicityrestore.sh'],
#    require => File['/tmp/restore/app_configuration.php','/tmp/restore/admin_configuration.php','/usr/local/sbin/configrestore.sh','/usr/local/sbin/mysqlrestore.sh'],
    command => '/bin/bash /usr/local/sbin/configrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
  }

}

