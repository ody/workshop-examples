class profile::device {

  include f5

  device_manager { 'f5-big-ip-0-vm':
    type         => 'f5',
    url          => 'https://admin:puppetlabs@10.138.0.5:8443/',
  }
}