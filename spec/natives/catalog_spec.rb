require 'spec_helper'
require 'natives/catalog'

describe Natives::Catalog do

  describe "#new" do
    it "loads catalogs" do
      Natives::Catalog.any_instance.should_receive(:reload)
      Natives::Catalog.new('rubygems', 'mac_os_x', '10.7.5', 'homebrew')
    end

    it "requires caller to provide platform and package provider details" do
      catalog = Natives::Catalog.new('rubygems', 'mac_os_x', '10.7.5', 'homebrew')
      expect(catalog.name).to eq('rubygems')
      expect(catalog.platform).to eq('mac_os_x')
      expect(catalog.platform_version).to eq('10.7.5')
      expect(catalog.package_provider).to eq('homebrew')
    end
  end

  describe "#reload" do
    it "reloads catalogs from default catalog paths" do
      Natives::Catalog::Loader.any_instance.
        should_receive(:load_from_paths).
        with(Natives::Catalog::CATALOG_PATHS).
        and_return({
          'rubygems' => {'foo' => {'key' => 'value'}},
          'npm' => {'bar' => {'key' => 'value'}}
        })

      catalog = Natives::Catalog.new('rubygems',
                                     'mac_os_x', '10.7.5', 'homebrew')

      expect(catalog.to_hash).to eq({'foo' => {'key' => 'value'}})
    end
  end

  describe "#to_hash" do
    before do
      Natives::Catalog::Loader.any_instance.
        stub(:load_from_paths).
        with(Natives::Catalog::CATALOG_PATHS).
        and_return({
          'rubygems' => {'foo' => {'key' => 'value'}},
          'npm' => {'bar' => {'key' => 'value'}}
        })
    end

    it "returns catalog hash of the specified catalog name" do
      catalog = Natives::Catalog.new("npm", nil, nil, nil)
      expect(catalog.to_hash).to eq({'bar' => {'key' => 'value'}})
    end

    it "returns empty hash if the sepcified catalog not found" do
      catalog = Natives::Catalog.new("notfound", nil, nil, nil)
      expect(catalog.to_hash).to eq({})
    end
  end

  describe "#native_packages_for" do
    before do
      Natives::Catalog::Loader.any_instance.
        stub(:load_from_paths).
        with(Natives::Catalog::CATALOG_PATHS).
        and_return({
          'rubygems' => {
            'nokogiri' => {
              'ubuntu/apt' => {
                '13.10' => 'value1',
                'default' => 'value2'
              }
            }
          },
        })
    end

    it "returns native packages for the given catalog entry name" do
      catalog = Natives::Catalog.new(:rubygems, 'ubuntu', '13.10', 'apt')
      expect(catalog.native_packages_for('nokogiri')).to eq(['value1'])
    end

    it "returns empty list if the given catalog entry name does not exist" do
      catalog = Natives::Catalog.new(:rubygems, 'ubuntu', '13.10', 'apt')
      expect(catalog.native_packages_for('notfound')).to eq([])
    end
  end

  describe "::CATALOG_PATHS" do
    it "contains the default catalog paths" do
      expect(Natives::Catalog::CATALOG_PATHS).to eq([
        Natives::Catalog::CATALOG_PATH_IN_GEM,
        Natives::Catalog::CATALOG_PATH_IN_WORKING_DIR
      ])
    end
  end

end
