require 'spec_helper'
require 'natives/catalog/selector'

describe Natives::Catalog::Selector do

  describe "#value_for" do
    let(:selector) do
      Natives::Catalog::Selector.new({
        apt: {
          default: 'apt-default',
          ubuntu: {
            '12.10' => 'ubuntu-12.10',
            %w(10.10 10.10.1 10.10.2) => %w(ubuntu-10.10s),
            'default' => %w(ubuntu-default1 ubuntu-default2)
          }
        },
        homebrew: {
          mac_os_x: {
            '10' => 'foo'
          }
        }
      })
    end

    it "returns values for a specific platform version" do
      expect(selector.values_for(:apt, :ubuntu, :'12.10')).to eq(
        ['ubuntu-12.10'])
    end
    it "returns a value for a specific platform version in version group" do
      expect(selector.values_for(:apt, :ubuntu, :'10.10.1')).to eq(
        ['ubuntu-10.10s'])
    end
    it "returns default version values when no matching platform version" do
      expect(selector.values_for('apt', 'ubuntu', '13')).to eq(
        ['ubuntu-default1', 'ubuntu-default2'])
    end
    it "returns default value when not matching platform" do
      expect(selector.values_for(:apt, :foo, :'13')).to eq(
        ['apt-default'])
    end
    it "returns empty list if there is no matching package provider" do
      expect(selector.values_for(:notfound, :ubuntu, '10')).to eq([])
    end
    it "returns nil if there is no default and no matching platform" do
      expect(selector.values_for(:homebrew, :notfound, 1)).to eq([])
    end
    it "returns nil if there is no default and no matching platform version" do
      expect(selector.values_for(:homebrew, :mac_os_x, '999')).to eq([])
    end
  end
end
