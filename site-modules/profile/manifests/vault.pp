class profile::vault {

  package { 'unzip': ensure => present } -> Class['vault']
  class { 'vault':
    purge_config_dir => false,
    listener => {
      'tcp' => {
        'address'       => "${facts['ipaddress']}:8200",
        'tls_disable'   => 0,
        'tls_cert_file' => '/etc/vault/ssl/certs/combined_crt.pem',
        'tls_key_file'  => '/etc/vault/ssl/private/pe-master-7b5a30-0.us-west1-a.c.slice-cody.internal.pem' 
      }
    }
  }
}
