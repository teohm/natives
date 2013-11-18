require 'natives/catalog/normalizer'

module Natives
  class Catalog
    class Selector
      def initialize(hash)
        @values = normalize(hash)
      end

      def values_for(package_provider, platform, platform_version)
        package_provider = package_provider.to_s
        platform = platform.to_s
        platform_version = platform_version.to_s

        values = nil
        platforms = @values.fetch(package_provider, nil)
        if platforms
          versions  = platforms.fetch(platform, nil)
          if versions
            values = versions.fetch(platform_version, nil) ||
              versions.fetch('default', nil)
          else
            values = platforms.fetch('default', nil)
          end
        end

        Array(values)
      end

      private

      def normalize(hash)
        Normalizer.new.normalize(hash)
      end

    end
  end
end
