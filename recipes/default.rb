cumulus_location = "/usr/local/cumulus"

directory cumulus_location do
    owner "root"
    group "root"
    mode 0755
    action :create
end

git cumulus_location do
  repository node[:cumulus][:git]
  reference node[:cumulus][:reference]
  action :sync
end

template "#{cumulus_location}/CumulusLib/Makefile" do
  source "CumulusLib-Makefile"
  owner "root"
  group "staff"
  mode 0640
end

template "#{cumulus_location}/CumulusServer/Makefile" do
  source "CumulusServer-Makefile"
  owner "root"
  group "staff"
  mode 0640
end

script "build cumulus" do
  interpreter "bash"
  cwd cumulus_location
  code <<-SH
  cd CumulusLib
  make
  cd ../CumulusService
  make
  echo "****************************************************"
  echo "****************************************************"
  echo "****************************************************"
  echo "Change ownership of #{cumulus_location} to your normal user before running the service!"
  echo "Otherwise it will abort trap."
  echo "****************************************************"
  echo "****************************************************"
  echo "****************************************************"
  SH
end

