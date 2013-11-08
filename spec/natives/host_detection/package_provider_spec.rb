require 'spec_helper'
require 'natives/host_detection/package_provider'

describe Natives::HostDetection::PackageProvider do
  it "detects host's package provider name" do
    platform = double()
    platform.should_receive(:name).and_return('ubuntu')

    package_provider = Natives::HostDetection::PackageProvider.new(platform)

    expect(package_provider.name).to eq('apt')
  end

  it "returns first package provider that exists in host" do
    platform = double()
    package_provider = Natives::HostDetection::PackageProvider.new(platform)
    platform.should_receive(:name).and_return('mac_os_x')
    package_provider.should_receive(:which).with('brew').and_return(nil)
    package_provider.should_receive(:which).
      with('port').and_return('/path/to/port')

    expect(package_provider.name).to eq('macports')
  end

  it "returns nil when detection fails" do
    platform = double()
    platform.should_receive(:name).and_return('unknown')

    package_provider = Natives::HostDetection::PackageProvider.new(platform)

    expect(package_provider.name).to be_nil
  end
end
