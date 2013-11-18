require 'natives/errors'

module Natives
  class Catalog
    class Normalizer

      def normalize(hash)
        normalize_package_provider_hash(hash)
      end

      protected

      def default?(str)
        'default' == str
      end

      def convert_to_hash(hash)
        return hash.to_h    if hash.respond_to?(:to_h)
        return hash.to_hash if hash.respond_to?(:to_hash)
        if block_given?
          yield
        else
          raise InvalidCatalogFormat
        end
      end

      def normalize_package_provider_hash(hash)
        hash = convert_to_hash(hash) do
          raise InvalidCatalogFormat,
            "expected a hash of package providers, but got: #{hash.inspect}"
        end

        hash.inject({}) do |normalized_hash, (k, v)|
          normalized_hash[k.to_s] = normalize_platform_hash(v)
          normalized_hash
        end
      end

      def normalize_platform_hash(hash)
        hash = convert_to_hash(hash) do
          raise InvalidCatalogFormat,
            "expected a hash of platforms, but got: #{hash.inspect}"
        end

        hash.inject({}) do |normalized_hash, (k, v)|
          platform = k.to_s
          value = if default?(platform)
                    normalize_native_package_list(v)
                  else
                    normalize_version_hash(v)
                  end
          normalized_hash[platform] = value
          normalized_hash
        end
      end

      def normalize_version_hash(hash)
        hash = convert_to_hash(hash) do
          raise InvalidCatalogFormat,
            "expected a hash of versions, but got: #{hash.inspect}"
        end

        hash.inject({}) do |normalized_hash, (k, v)|
          versions = Array(k)
          versions.each do |version|
            normalized_hash[version.to_s] = normalize_native_package_list(v)
          end
          normalized_hash
        end
      end

      def normalize_native_package_list(list)
        Array(list)
      end
    end
  end
end
