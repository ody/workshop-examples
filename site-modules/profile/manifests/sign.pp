class profile::sign {
    ini_setting { 'policy-based autosigning':
      setting => 'autosign',
      path    => "${settings::confdir}/puppet.conf",
      section => 'master',
      value   => '/opt/puppetlabs/puppet/bin/autosign-validator',
      notify  => Service['pe-puppetserver'],
    }

   class { 'autosign':
     ensure => 'latest',
     config => {
       'general' => {
         'loglevel' => 'INFO',
       },
     }
   }
}
