# spec/Dockerfile_spec.rb

require "serverspec"
require "docker"

describe "Dockerfile" do
  before(:all) do
    image = Docker::Image.build_from_dir('.')

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
  end

  it "installs the right version of Ubuntu" do
    expect(os_version).to include("Ubuntu 18")
  end

  # Check Netbeans install
  it "installs required packages" do
    expect(package("netbeans")).to be_installed
  end

  # Check Octave install
    it "installs required packages" do
      expect(package("octave")).to be_installed
  end
  
  # Check ruby install
  it "installs required packages" do
    expect(package("ruby")).to be_installed
  end

  # Check the version of NVIDIA installed 
  describe command("grep '418.88' /var/log/nvidia-installer.log") do
    its(:stdout) { should match /Installing NVIDIA driver version 418.88./ }
  end
  
  # Check the CUDA version installed
  describe command("grep '10.0.130' /opt/cuda/version.txt") do
    its(:stdout) { should match /CUDA Version 10.0.130/ }
  end

  def os_version
    command("lsb_release -a").stdout
  end
end
