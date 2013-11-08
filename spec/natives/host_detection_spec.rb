require 'spec_helper'
require 'natives/host_detection'

describe Natives::HostDetection do
  it "detects host's platform" do
    detect_platform = double()
    detect_platform.stub(:name).and_return('foobar')
    detect = Natives::HostDetection.new(
      detect_package_provider: nil,
      detect_platform: detect_platform)

    expect(detect.platform).to eq('foobar')
  end

  it "detects host's platform version" do
    detect_platform = double()
    detect_platform.stub(:version).and_return('1')
    detect = Natives::HostDetection.new(
      detect_package_provider: nil,
      detect_platform: detect_platform)

    expect(detect.platform_version).to eq('1')
  end

  it "detects host's package provider" do
    detect_package_provider = Natives::HostDetection::PackageProvider.new(
      double())
    detect_package_provider.stub(:name).and_return('yummy')
    detect = Natives::HostDetection.new(
      detect_platform: nil,
      detect_package_provider: detect_package_provider)

    expect(detect.package_provider).to eq('yummy')
  end

  it "uses Platform and PackagePacker by default" do
    Natives::HostDetection::Platform.should_receive(:new).
      and_return('foo')
    Natives::HostDetection::PackageProvider.should_receive(:new).
      with('foo')

    Natives::HostDetection.new
  end

end
