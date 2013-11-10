require 'bundler'

module Natives
  class GemfileViewer
    def initialize(gemfile_path)
      @gemfile_path = gemfile_path
      @lockfile_path = "#{gemfile_path}.lock"
    end

    def gem_names
      lockfile = Bundler::LockfileParser.new(Bundler.read_file(@lockfile_path))
      lockfile.specs.map(&:name)
    end

  end
end
