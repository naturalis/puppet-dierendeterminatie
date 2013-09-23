# Parameters:
#
class dierendeterminatie::backmeup (
  $backuphour = undef,
  $backupminute = undef,
  $backupdir = undef,
  $bucket = undef,
  $dest_id = undef,
  $dest_key = undef,
  $cloud = undef,
  $pubkey_id = undef,
  $full_if_older_than = undef,
  $remove_older_than = undef,
)
{
  notify {'Backup enabled':}

  duplicity { 'backup':
    directory          => $backupdir,
    bucket             => $bucket,
    dest_id            => $dest_id,
    dest_key           => $dest_key,
    cloud              => $cloud,
    pubkey_id          => $pubkey_id,
    hour               => $backuphour,
    minute             => $backupminute,
    full_if_older_than => $full_if_older_than,
    remove_older_than  => $remove_older_than,
    pre_command        => '/usr/local/sbin/configbackup.sh && /usr/local/sbin/mysqlbackup.sh',
    require            => Class['mysql::backup'],
  }

  file { "/usr/local/sbin/configbackup.sh":                                                                                                                                        
    content => template('dierendeterminatie/configbackup.sh.erb'),                                                                                                                                    
    mode    => '0700',                                                                                                                                                                  
  }                                                                                                                                                                                     
                                                                                                                                                                                
}

