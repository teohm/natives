require 'spec_helper'
require 'natives/apps/detect'

describe Natives::Apps::Detect do
  it "detects host's platform and package provider info" do
    app = Natives::Apps::Detect.new

    host_detection = double()
    host_detection.stub(platform: 'ubuntu')
    host_detection.stub(platform_version: '12.3.2')
    host_detection.stub(package_provider: 'apt')
    app.should_receive(:new_host_detection).
      and_return(host_detection)

    expect(app.detection_info).to eq([
      'platform: ubuntu',
      'platform_version: 12.3.2',
      'package_provider: apt'
    ].join("\n"))
  end

  it "uses HostDetection" do
    app = Natives::Apps::Detect.new
    expect(app.new_host_detection).to be_kind_of Natives::HostDetection
  end
end
