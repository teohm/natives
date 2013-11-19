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
        macports: {
          default: 'macports-default',
          mac_os_x: {
            '10' => 'bar'
          }
        },
        homebrew: {
          mac_os_x: {
            '10' => 'foo'
          }
        }
      })
    end

    it "returns values for matching platform version" do
      selector = Natives::Catalog::Selector.new({
        apt: {
          ubuntu: {
            '12.10' => 'value'
          }
        }
      })
      expect(selector.values_for(:apt, :ubuntu, '12.10')).to eq(
        ['value'])
    end

    it "returns a value for matching platform version in version list" do
      selector = Natives::Catalog::Selector.new({
        apt: {
          ubuntu: {
            ['12.10.1', '12.10', '12.10.2'] => 'value'
          }
        }
      })
      expect(selector.values_for(:apt, :ubuntu, '12.10')).to eq(
        ['value'])
    end

    it "returns default version values when no matching platform version" do
      selector = Natives::Catalog::Selector.new({
        apt: {
          ubuntu: {
            ['12.10.1', '12.10', '12.10.2'] => 'value',
            default: 'value-default'
          }
        }
      })
      expect(selector.values_for(:apt, :ubuntu, '99')).to eq(
        ['value-default'])
    end

    it "returns default value when not matching platform" do
      selector = Natives::Catalog::Selector.new({
        apt: {
          ubuntu: {
            ['12.10.1', '12.10', '12.10.2'] => 'ubuntu-value',
            default: 'ubuntu-value-default'
          },
          default: 'value'
        }
      })
      expect(selector.values_for(:apt, :foo, '12.10.1')).to eq(
        ['value'])
    end

    it "returns default value when not matching platform version, and no version default value" do
      selector = Natives::Catalog::Selector.new({
        apt: {
          ubuntu: {
            ['12.10.1', '12.10', '12.10.2'] => 'ubuntu-value',
          },
          default: 'value'
        }
      })
      expect(selector.values_for(:apt, :ubuntu, '99')).to eq(
        ['value'])
    end

    it "returns empty list if there is no matching package provider" do
      selector = Natives::Catalog::Selector.new({
        apt: {
          ubuntu: {
            default: 'value'
          }
        }
      })
      expect(selector.values_for(:foo, :ubuntu, '99')).to eq([])
    end

    it "returns empty list if there is no default and no matching platform" do
      selector = Natives::Catalog::Selector.new({
        apt: {
          ubuntu: {
            '10.10' => 'value'
          }
        }
      })
      expect(selector.values_for(:apt, :foo, '10.10')).to eq([])
    end
    it "returns empty list if there is no default and no matching platform version" do
      selector = Natives::Catalog::Selector.new({
        apt: {
          ubuntu: {
            '10.10' => 'value'
          }
        }
      })
      expect(selector.values_for(:apt, :ubuntu, '99')).to eq([])
    end
  end
end
