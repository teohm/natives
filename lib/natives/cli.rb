require 'thor'
require 'natives/apps/list'

module Natives
  class Cli < Thor

    desc 'list [ENTRY1 ENTRY2 ..]',
      'list native packages required by the catalog entries'
    method_option :catalog, default: 'rubygems', aliases: '-c',
      desc: 'use this catalog'
    method_option :gemfile, default: 'Gemfile',
      desc: 'use gems in the gemfile as the catalog entries'
    def list(*entry_names)
      catalog_name = options[:catalog]
      $stderr.puts "catalog: #{catalog_name}"

      app = Apps::List.new

      if catalog_name == 'rubygems' && entry_names.empty?
        packages = app.natives_for_gemfile(options[:gemfile])
      else
        $stderr.puts "entries: #{entry_names}"
        packages = app.natives_for(catalog_name, entry_names)
      end

      puts packages
    rescue => ex
      $stderr.puts ex.message
    end
  end
end
