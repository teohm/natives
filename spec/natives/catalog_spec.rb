require 'spec_helper'
require 'natives/catalog'

describe Natives::Catalog do

  describe "#new" do
    it "loads catalogs" do
      Natives::Catalog.any_instance.should_receive(:reload)
      Natives::Catalog.new('rubygems', 'mac_os_x', '10.7.5', 'homebrew')
    end

    it "requires caller to provide platform and package provider details" do
      catalog = Natives::Catalog.new('rubygems',
                                     'mac_os_x', '10.7.5',
                                     'homebrew')

      expect(catalog.name).to eq('rubygems')
      expect(catalog.platform).to eq('mac_os_x')
      expect(catalog.platform_version).to eq('10.7.5')
      expect(catalog.package_provider).to eq('homebrew')
    end
  end

  describe "#reload" do
    it "reloads catalogs from default catalog paths" do
      loader = double()
      loader.
        should_receive(:load_from_paths).
        with([
          Natives::Catalog::CATALOG_PATH_IN_GEM,
          File.absolute_path(File.join(Dir.pwd, 'natives-catalogs'))
        ]).
        and_return({
          'rubygems' => {'foo' => {'key' => 'value'}},
          'npm' => {'bar' => {'key' => 'value'}}
        })

      catalog = Natives::Catalog.new('rubygems',
                                     'mac_os_x', '10.7.5', 'homebrew',
                                     loader: loader)

      expect(catalog.to_hash).to eq({'foo' => {'key' => 'value'}})
    end

    it "reloads catalogs from given working directory" do
      loader = double()
      loader.
        should_receive(:load_from_paths).
        with([
          Natives::Catalog::CATALOG_PATH_IN_GEM,
          '/path/to/working_dir/natives-catalogs'
        ]).
        and_return({
          'rubygems' => {'foo' => {'key' => 'value'}},
          'npm' => {'bar' => {'key' => 'value'}}
        })

      catalog = Natives::Catalog.new('rubygems',
                                     'mac_os_x', '10.7.5', 'homebrew',
                                     loader: loader,
                                     working_dir: '/path/to/working_dir')

      expect(catalog.to_hash).to eq({'foo' => {'key' => 'value'}})

    end
  end

  describe "#to_hash" do
    before do
      Natives::Catalog::Loader.any_instance.
        stub(:load_from_paths).
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
        and_return({
          'rubygems' => {
            'nokogiri' => {
              'ubuntu/apt' => {
                '13.10' => 'value1',
                'default' => 'value2'
              }
            },
            'curb' => {
              'ubuntu/apt' => {
                'default' => 'value3'
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

    it "return native packages for the given catalog entry name list" do
      catalog = Natives::Catalog.new(:rubygems, 'ubuntu', '13.10', 'apt')
      expect(catalog.native_packages_for(
        'nokogiri', 'notfound', 'curb')).to eq(['value1', 'value3'])
    end

    it "return native packages for the given catalog entry name array" do
      catalog = Natives::Catalog.new(:rubygems, 'ubuntu', '13.10', 'apt')
      expect(catalog.native_packages_for(
        ['nokogiri', 'notfound', 'curb'])).to eq(['value1', 'value3'])
    end
  end

end
