require 'natives/catalog/merger'
require 'psych'
require 'yaml'

module Natives
  class Catalog
    class Loader
      def initialize(opts={})
        @merger = opts.fetch(:merger, Merger.new)
      end

      def load_from_paths(paths)
        master_hash = {}
        Array(paths).each do |path|
          yaml_files_in_path(path).sort.each do |file|
            @merger.merge_catalog!(master_hash, load_yaml_file(file))
          end
        end
        master_hash
      end

      def yaml_files_in_path(path)
        Dir.glob(File.join(path, '*.{yml,yaml}'))
      end

      def load_yaml_file(filename)
        YAML.load_file(filename)
      end
    end
  end
end
