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
    mode    => '0700',
  }

  exec { 'duplicityrestore.sh':
    command => '/bin/bash /usr/local/sbin/duplicityrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
    require => File['/usr/local/sbin/duplicityrestore.sh','/usr/local/sbin/configrestore.sh','/usr/local/sbin/mysqlrestore.sh'],
  }

  exec { 'mysqlrestore.sh':
    command => '/bin/bash /usr/local/sbin/mysqlrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
    require => Exec['duplicityrestore.sh'],
  }

  exec { 'configrestore.sh':
    command => '/bin/bash /usr/local/sbin/configrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
    require => Exec['duplicityrestore.sh'],
  }

}

