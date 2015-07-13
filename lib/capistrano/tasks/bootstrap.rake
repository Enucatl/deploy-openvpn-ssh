tmp_dir = "/tmp/puppet-conf"

file "openvpn.tar.gz" => `git ls-files`.split("\n") do |t|
  sh "tar czf #{t.name} #{t.prerequisites.join(' ')}"
end

namespace :'puppet-bootstrap' do

  desc "update the ubuntu packages"
  task :'update-packages' do
    on roles(:root) do
        execute "apt-get update; DEBIAN_FRONTEND=noninteractive apt-get -y upgrade"
    end
  end

  desc "install the ubuntu packages"
  task :'install-packages' => :"update-packages" do
    packages = %w(git puppet ruby-dev make)
    on roles(:root) do
      packages.each do |p|
        execute "dpkg -s #{p} &> /dev/null; if [ $? -ne 0 ]; then DEBIAN_FRONTEND=noninteractive apt-get -y install #{p}; fi"
      end
    end
  end

  desc "install r10k"
  task :'install-r10k' => :'install-packages' do
    on roles(:root) do
      execute "if [ -z $(which r10k) ]; then gem install r10k --no-ri --no-rdoc; fi"
    end
  end

  desc "Package and upload the configs"
  task :'upload-config' => ["openvpn.tar.gz", :'install-r10k'] do |t|
    tarball = t.prerequisites.first
    on roles(:root) do
      execute :mkdir, '-p', tmp_dir
      upload!(tarball, tmp_dir)
      within tmp_dir do
        execute :tar, 'xzf', tarball
      end
    end
  end

  desc "run puppet librarian"
  task :'puppet-r10k' => :"upload-config" do
    on roles(:root) do
      within tmp_dir do
        execute :"r10k", "puppetfile install"
      end
    end
  end

  desc "puppet apply"
  task :'puppet-apply' => :"puppet-r10k" do
    on roles(:root) do
      within tmp_dir do
        execute :puppet, "apply",  "--modulepath=./modules", "site.pp"
      end
    end
  end
end

task :bootstrap => 'puppet-bootstrap:puppet-apply'
