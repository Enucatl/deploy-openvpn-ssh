Deploy an OpenVPN Access Server
============================

On Ubuntu:

```bash:
git clone https://github.com/Enucatl/deploy-openvpn-ssh.git
cd deploy-openvpn-ssh
```

Edit the `site.pp` file, and put your
* password hash for the deploy and openvpn users. The password must be already encrypted, that is ready to be copied into /etc/shadow as is.
* the location of your public keys for a passwordless ssh login, for github users it is `https://github.com/<username>.keys`

If you don't have them already install ruby and bundler on your computer:
```bash:
sudo apt-get install ruby
gem install bundler
bundle install
```

After you create an ubuntu 14.04 droplet on
(digitalocean)[www.digitalocean.com] copy its IP address and you're ready to
go:

```bash:
SERVER_ADDRESS=your.ip.address cap bootstrap
```

After a couple of minutes openvpn access server will be installed and
running, just visit `https://your.ip.address` and follow the on screen
instructions.

Notes
=====

This package also installs (minimum security)[https://github.com/Enucatl/minimum_security] features on your server. Most
notably only allowing public key ssh authentication, and disabling root
login altogether. A `deploy` user is created with `sudo` capabilities
though.
