require 'spec_helper'
require 'natives/host_detection/platform'

describe Natives::HostDetection::Platform do
  let(:platform) { Natives::HostDetection::Platform.new }

  it "detects platform name" do
    platform.should_receive(:ohai_hash).and_return({platform: 'ubuntu'})
    expect(platform.name).to eq('ubuntu')
  end

  it "detects platform version" do
    platform.should_receive(:ohai_hash).
      and_return({platform_version: '12'})
    expect(platform.version).to eq('12')
  end

  it "uses Ohai" do
    expect(platform.ohai_hash).to be_kind_of Ohai::System
  end
end
