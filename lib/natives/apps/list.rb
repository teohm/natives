require 'natives/host_detection'
require 'natives/catalog'
require 'natives/gemfile_viewer'

module Natives
  module Apps
    class List

      def natives_for(catalog_name, entry_names)
        host = new_host_detection
        catalog = new_catalog(catalog_name,
                              host.platform, host.platform_version,
                              host.package_provider)
        catalog.native_packages_for(entry_names)
      end

      def natives_for_gemfile(gemfile_path)
        host = new_host_detection
        gem_names = new_gemfile_viewer(gemfile_path).gem_names
        catalog = new_catalog('rubygems',
                              host.platform, host.platform_version,
                              host.package_provider)
        catalog.native_packages_for(gem_names)
      end

      def new_gemfile_viewer(gemfile_path)
        GemfileViewer.new(gemfile_path)
      end

      def new_catalog(catalog_name, platform, platform_version, package_provider)
        Catalog.new(catalog_name, platform, platform_version, package_provider)
      end

      def new_host_detection
        HostDetection.new
      end
    end
  end
end
