module Natives
  class Catalog
    class Selector
      def initialize(platform_hash)
        assert_valid_platform_hash(platform_hash)
        @values = normalize_platform_hash(platform_hash)
      end

      def value_for(platform, platform_version, package_provider)
        key = "#{platform.to_s}/#{package_provider.to_s}"
        if @values.key?(key) && @values[key].key?(platform_version)
          @values[key][platform_version]
        elsif @values.key?(key) && @values[key].key?('default')
          @values[key]['default']
        elsif @values.key?('default')
          @values['default']
        else
          nil
        end
      end

      protected

      def normalize_platform_hash(platform_hash)
        normalized_hash = {}
        platform_hash.each do |keys, value|
          if keys.to_s == 'default'
            normalized_hash['default'] = value
          else
            Array(keys).each do |key|
              normalized_hash[key.to_s] = normalize_keys(value)
            end
          end
        end
        normalized_hash
      end

      def normalize_keys(hash)
        normalized_hash = {}
        hash.each do |keys, value|
          Array(keys).each do |key|
            normalized_hash[key.to_s] = value
          end
        end
        normalized_hash
      end

      def assert_valid_platform_hash(platform_hash)
        unless platform_hash.kind_of? Hash
          raise ArgumentError, 'catalog entry should be a hash'
        end

        platform_hash.each do |platforms, value|
          assert_valid_key_and_value(platforms, value)
        end
      end

      def assert_valid_key_and_value(platforms, value)
        return if platforms.to_s == 'default'

        keys = platforms.kind_of?(Array) ? platforms : [platforms]
        keys.each do |key|
          if (%r{\A.+/.+\Z} =~ key.to_s) == nil && key.to_s != 'default'
            msg = "Found an invalid key: #{key.inspect}. "
            msg << "A valid key should be in this format: 'platform/package_provider'."
            raise ArgumentError, msg
          end
        end

        unless value.kind_of? Hash
          msg = "Found an invalid value: #{value.inspect} "
          msg << "for key: #{platforms.inspect}. The value should be a Hash."
          raise ArgumentError, msg
        end
      end

    end
  end
end
