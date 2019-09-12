# spec/Dockerfile_spec.rb

require_relative "spec_helper"

describe "Dockerfile" do
  before(:all) do
    load_docker_image()
    set :os, family: :debian
  end

  describe "Dockerfile#running" do
    it "runs the right version of Debian" do
      expect(os_version).to include("Debian")
      expect(os_version).to include("GNU/Linux 10")
    end
    it "runs as service user" do
      package_name = "root"
      expect(sys_user).to eql(package_name)
    end
  end

  describe command("vault version") do
    package_version = ENV['PACKAGE_VERSION']
    its(:stdout) { should match("#{package_version}") }
    its(:exit_status) { should eq 0 }
  end
end
