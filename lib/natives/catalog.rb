require 'natives/catalog/loader'
require 'natives/catalog/selector'

module Natives
  class Catalog

    CATALOG_PATH_IN_GEM = File.absolute_path(File.join(
                            File.dirname(__FILE__), '..', '..', 'catalogs'))

    WORKING_DIR_CATALOG_DIRNAME = 'natives-catalogs'

    attr_reader :platform, :platform_version, :package_provider, :name

    def initialize(catalog_name,
                   platform, platform_version,
                   package_provider,
                   opts={})

      @name = catalog_name.to_s
      @platform = platform.to_s
      @platform_version = platform_version.to_s
      @package_provider = package_provider.to_s

      @loader = opts.fetch(:loader, Loader.new)
      @working_dir = opts.fetch(:working_dir, Dir.pwd)

      reload
    end

    def reload
      @catalogs = @loader.load_from_paths(catalog_paths)
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

    protected

    def catalog_paths
      [
        CATALOG_PATH_IN_GEM,
        File.absolute_path(File.join(@working_dir, WORKING_DIR_CATALOG_DIRNAME))
      ]
    end

  end
end
