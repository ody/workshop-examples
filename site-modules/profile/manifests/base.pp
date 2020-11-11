class profile::base($password) {

#  if $facts['trusted']['extenstions']['1.3.6.1.4.1.34380.1.1.9812'] == 'puppet/master' {
#    $variables = {
#      'password' => Deferred('vault_lookup::lookup', ['secret/data/databases', 'https://pe-master-7b5a30-0.us-west1-a.c.slice-cody.internal:8200'])
#    }
#  } else {
#    $variables = {
#      'password' => Deferred('vault_lookup::lookup', ['secret/data/common/databases', 'https://pe-master-7b5a30-0.us-west1-a.c.slice-cody.internal:8200'])
#    }
#  }

  # compile the template source into the catalog
#  notify { 'foo':
#    message => Deferred('inline_epp', ['<%= $password.unwrap["password"] %>', $variables]),
#  }
  notify { 'foo':
    message => $password,
  }
#}
