module Natives
  class Catalog
    class Validator
      def ensure_valid_catalog_groups(hash)
        unless hash.kind_of? Hash
          raise ArgumentError, 'catalog should be a Hash'
        end

        invalid_groups = hash.select {|key, value| !value.kind_of?(Hash) }
        unless invalid_groups.empty?
          group_names = invalid_groups.keys
          raise ArgumentError,
            "The following catalog group(s) should be a Hash: #{group_names.join(', ')}"
        end
      end
    end
  end
end
