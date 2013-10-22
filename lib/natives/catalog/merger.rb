require 'natives/catalog/validator'

module Natives
  class Catalog
    class Merger
      def initialize(opts={})
        @validator = opts.fetch(:validator, Validator.new)
      end

      def merge_catalog!(master_hash, hash_to_merge)
        @validator.ensure_valid_catalog_groups(master_hash)
        @validator.ensure_valid_catalog_groups(hash_to_merge)

        hash_to_merge.each do |group_name, entries|
          if master_hash.key? group_name
            master_hash[group_name].merge! entries
          else
            master_hash[group_name] = entries
          end
        end

        master_hash
      end
    end
  end
end
