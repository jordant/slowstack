Vagrant.configure("2") do |config|
  config.vm.box = "openstack"
  config.ssh.private_key_path = "~/.ssh/bootstrap"
  config.vm.provider :openstack do |os|
      os.server_name = "vagrant-openstack"
      os.username = "#{ENV['OS_USERNAME']}"
      os.api_key = "#{ENV['OS_PASSWORD']}"
      os.tenant   = "#{ENV['OS_TENANT_NAME']}"
      os.flavor       = "100"                # Regex or String
      os.image        = "#{ENV['OS_IMAGE_ID']}"
      os.endpoint     = "#{ENV['OS_AUTH_URL']}/tokens"
      os.keypair_name = "bootstrap"
      os.ssh_username = "dhc-user"    
      os.networks           = [ "private-network" ]
  end
  config.vm.provision "shell", path: "post.sh", privileged: false
end
