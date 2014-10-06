class { 'minimum_security':
  user => 'deploy',
  password => '$1$D5KK5H7a$OCs4OnweVdEe/ll2ZevPd1',
  ssh_key_location => 'https://github.com/enucatl.keys',
}

class {'openvpn_as':
  openvpn_location => 'http://swupdate.openvpn.org/as/openvpn-as-2.0.10-Ubuntu14.amd_64.deb',
  password => '$1$D5KK5H7a$OCs4OnweVdEe/ll2ZevPd1',
}
