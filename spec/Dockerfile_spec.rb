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


  def os_version
    command("lsb_release -a").stdout
  end
end