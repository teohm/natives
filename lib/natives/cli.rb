require 'thor'
require 'natives/apps'

module Natives
  class Cli < Thor

    desc 'list [ENTRY1 ENTRY2 ..]',
      'list native packages required by the catalog entries'
    method_option :catalog, default: 'rubygems', aliases: '-c',
      desc: 'use this catalog'
    method_option :gemfile, default: 'Gemfile',
      desc: 'use gems in the gemfile as the catalog entries'
    def list(*entry_names)
      app = Apps::List.new

      catalog_name = options[:catalog]
      if catalog_name == 'rubygems' && entry_names.empty?
        packages = app.natives_for_gemfile(options[:gemfile])
      else
        packages = app.natives_for(catalog_name, entry_names)
      end

      puts packages
    rescue => ex
      $stderr.puts ex.message
    end

    desc 'detect',
      'detect and print platform and package provider information'
    def detect
      app = Apps::Detect.new
      puts app.detection_info
    end

    desc 'version',
      'print version information'
    def version
      version_file = File.expand_path(File.join(
        File.dirname(__FILE__), '..', '..', 'VERSION'))

      puts IO.read(version_file)
    end
  end

end
