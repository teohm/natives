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

        values = if @values.key?(package_provider) &&
                   @values[package_provider].key?(platform) &&
                   @values[package_provider][platform].key?(platform_version)

                   @values[package_provider][platform][platform_version]

                 elsif @values.key?(package_provider) &&
                   @values[package_provider].key?(platform) &&
                   @values[package_provider][platform].key?('default')

                   @values[package_provider][platform]['default']

                 elsif @values.key?(package_provider) &&
                   @values[package_provider].key?('default')

                   @values[package_provider]['default']
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
