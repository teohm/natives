require 'spec_helper'
require 'natives/catalog/selector'

describe Natives::Catalog::Selector do
  describe "#new" do

    describe "assert valid platform hash" do
      it "raises error if platform hash is not a hash" do
        expect {
          Natives::Catalog::Selector.new(nil)
        }.to raise_error(ArgumentError, "catalog entry should be a hash")
      end

      it "raises error when found an invalid string as hash key" do
        expect {
          Natives::Catalog::Selector.new({
            "mac_os_x/homebrew" => {"default" => "value"},
            "ubuntu" => {"default" => "value"},
            "debian" => {"default" => "value"}
          })
        }.to raise_error ArgumentError, /Found an invalid key: "ubuntu"/
      end

      it "raises error when found an invalid array as hash key" do
        expect {
          Natives::Catalog::Selector.new({
            ["fedora/yum", "redhat/yum"] => {"default" => "value"},
            ["centos/yum", "oracle"] => {"default" => "value"},
          })
        }.to raise_error ArgumentError, /Found an invalid key: "oracle"/
      end

      it "raises error if platform hash's value is not a hash" do
        expect {
          Natives::Catalog::Selector.new({
            "ubuntu/apt" => "value",
            "mac_os_x/homebrew" => {"default" => "value"},
          })
        }.to raise_error ArgumentError, /Found an invalid value: "value"/
      end

      it "accepts default platform value" do
        expect {
          Natives::Catalog::Selector.new({
            "default" => "value"
          })
        }.not_to raise_error
      end
    end

    describe "normalize platform hash" do
      class ProxySelector < Natives::Catalog::Selector
        def normalized_values
          @values
        end
      end

      it "expand platform array" do
        expect(ProxySelector.new({
          "mac_os_x/homebrew" => {"default" => "value1"},
          ["ubuntu/apt", "debian/apt"] => {"default" => "value2"}
        }).normalized_values).to eq({
          "mac_os_x/homebrew" => {"default" => "value1"},
          "ubuntu/apt" => {"default" => "value2"},
          "debian/apt" => {"default" => "value2"}
        })
      end

      it "expand version array" do
        expect(ProxySelector.new({
          "mac_os_x/homebrew" => {
            "default" => "value1",
            ["v1", "v2"] => "value2"
          }
        }).normalized_values).to eq({
          "mac_os_x/homebrew" => {
            "default" => "value1",
            "v1" => "value2",
            "v2" => "value2"
          }
        })
      end
    end
  end

  describe "#value_for" do
    it "returns the default value when the platform/package_provider doesn't match" do
      expect(
        Natives::Catalog::Selector.new({
          "ubuntu/apt" => {"default" => "libcurl"},
          "default" => "curl"
        }).value_for('mac_os_x', '10.7.5', 'homebrew')
      ).to eq('curl')
    end

    it "returns a value for a specific platform version" do
      expect(
        Natives::Catalog::Selector.new({
          ["mac_os_x/homebrew", "mac_os_x/macports"] => {
            "10.7.5" => "curl", "default" => "foo"},
          "default" => "bar"
        }).value_for('mac_os_x', '10.7.5', 'homebrew')
      ).to eq('curl')
    end

    it "returns a platform-default value if the platform version doesn't match an explicit one" do
      expect(
        Natives::Catalog::Selector.new({
          "mac_os_x/homebrew" => {
            "10.7.5" => "curl", "default" => "foo"},
          "default" => "bar"
        }).value_for('mac_os_x', '10.8.0', 'homebrew')
      ).to eq('foo')
    end

    it "returns nil if there is no default and no platforms match" do
      expect(
        Natives::Catalog::Selector.new({
          ["mac_os_x/homebrew", "mac_os_x/macports"] => {"10.7.5" => "curl"}
        }).value_for('mac_os_x', '10.8.0', 'homebrew')
      ).to be_nil
    end
  end
end
