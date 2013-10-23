require 'natives/catalog/loader'

module Natives
  class Catalog

    CATALOG_PATH_IN_GEM = File.absolute_path(File.join(
                            File.dirname(__FILE__), '..', '..', 'catalogs'))
    CATALOG_PATH_IN_WORKING_DIR = File.absolute_path(File.join('.', 'natives-catalogs'))

    CATALOG_PATHS = [
      CATALOG_PATH_IN_GEM,
      CATALOG_PATH_IN_WORKING_DIR
    ].freeze

    def self.load
      loader = new_loader
      loader.load_from_paths(CATALOG_PATHS)
    end

    def self.new_loader
      Loader.new
    end

  end
end
