require 'spec_helper'
require 'natives/catalog/normalizer'

describe "Catalog Normalizer" do
  let(:normalizer) { Natives::Catalog::Normalizer.new }

  context "Given valid hash input" do
    it "converts package provider, platform, platform version to string" do
      hash = normalizer.normalize({
        :macports => {
          :mac_os_x => {
            :default => ['foo'],
            :"10.1.2" => ['bar']
          }
        }
      })

      expect(hash).to eq({
        'macports' => {
          'mac_os_x' => {
            'default' => ['foo'],
            '10.1.2' => ['bar']
          }
        }
      })
    end

    it "supports default platform" do
      hash = normalizer.normalize({
        apt: {
          default: ['foo'],
          ubuntu: {
            default: ['bar']
          }
        }
      })

      expect(hash).to eq({
        'apt' => {
          'default' => ['foo'],
          'ubuntu' => {
            'default' => ['bar']
          }
        }
      })
    end

    it "normalizes version list" do
      hash = normalizer.normalize({
        apt: {
          ubuntu: {
            :default => ['bar'],
            '13' => ['top'],
            ['11','12','13'] => ['foo'],
            '11' => ['bottom']
          }
        }
      })

      expect(hash).to eq({
        'apt' => {
          'ubuntu' => {
            'default' => ['bar'],
            '13' => ['foo'],
            '11' => ['bottom'],
            '12' => ['foo']
          }
        }
      })
    end

    it "ensures native packages is a list" do
      hash = normalizer.normalize({
        apt: {
          default: 'defaultfoo',
          ubuntu: {
            :default => 'bar',
            '14' => 'top',
            ['11','12','13'] => 'foo',
          }
        }
      })

      expect(hash).to eq({
        'apt' => {
          'default' => ['defaultfoo'],
          'ubuntu' => {
            'default' => ['bar'],
            '14' => ['top'],
            '11' => ['foo'],
            '12' => ['foo'],
            '13' => ['foo']
          }
        }
      })
    end

  end

  context "Invalid input" do

    it "raises error when package provider hash is not a hash" do
      expect {
        normalizer.normalize("invalid")
      }.to raise_error Natives::InvalidCatalogFormat

    end

    it "raises error when platform hash is not a hash" do
      expect {
        normalizer.normalize({
          "macports" => "invalid"
        })
      }.to raise_error Natives::InvalidCatalogFormat
    end

    it "raises error when version hash is not a hash" do
      expect {
        normalizer.normalize({
          "macports" => {
            "ubuntu" => nil
          }
        })
      }.to raise_error Natives::InvalidCatalogFormat
    end

  end
end
