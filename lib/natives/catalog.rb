require 'natives/catalog/loader'
require 'natives/catalog/selector'

module Natives
  class Catalog

    CATALOG_PATH_IN_GEM = File.absolute_path(File.join(
                            File.dirname(__FILE__), '..', '..', 'catalogs'))
    CATALOG_PATH_IN_WORKING_DIR = File.absolute_path(File.join('.', 'natives-catalogs'))

    CATALOG_PATHS = [
      CATALOG_PATH_IN_GEM,
      CATALOG_PATH_IN_WORKING_DIR
    ].freeze

    attr_reader :platform, :platform_version, :package_provider, :name

    def initialize(catalog_name, platform, platform_version, package_provider)
      reload

      @name = catalog_name.to_s
      @platform = platform.to_s
      @platform_version = platform_version.to_s
      @package_provider = package_provider.to_s
    end

    def reload
      @catalogs = Loader.new.load_from_paths(CATALOG_PATHS)
    end

    def to_hash
      @catalogs.fetch(self.name, {})
    end

    def native_packages_for(*entry_names)
      packages = Array(entry_names).flatten.map do |entry_name|
        Selector.new(self.to_hash.fetch(entry_name, {})).
          value_for(@platform, @platform_version, @package_provider)
      end
      packages.flatten.compact
    end

  end
end
