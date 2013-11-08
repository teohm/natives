require 'spec_helper'
require 'natives/apps/list'

describe Natives::Apps::List do
  context "given catalog entry names" do
    it "lists native packages" do
      catalog_name = 'rubygems'
      entry_names = %w(sqlite3 capybara-webkit nokogiri curb)

      catalog = double()
      catalog.should_receive(:native_packages_for).
        with(entry_names).
        and_return(%w(foo bar spam))

      host_detection = double()
      host_detection.should_receive(:platform)
      host_detection.should_receive(:platform_version)
      host_detection.should_receive(:package_provider)

      list = Natives::Apps::List.new
      list.stub(new_catalog: catalog)
      list.stub(new_host_detection: host_detection)

      packages = list.natives_for(catalog_name, entry_names)

      expect(packages).to eq %w(foo bar spam)
    end
  end

  context "given a gemfile path" do
    it "lists native packages" do
      gemfile_path = 'path/to/gemfile'
      list = Natives::Apps::List.new

      gemfile_viewer = double()
      gemfile_viewer.should_receive(:gem_names).
        and_return(%w(gem1 gem2 gem3))

      host_detection = double()
      host_detection.should_receive(:platform)
      host_detection.should_receive(:platform_version)
      host_detection.should_receive(:package_provider)

      catalog = double()
      catalog.should_receive(:native_packages_for).
        with(%w(gem1 gem2 gem3)).
        and_return(%w(foo bar spam))

      list.stub(new_gemfile_viewer: gemfile_viewer)
      list.stub(new_catalog: catalog)
      list.stub(new_host_detection: host_detection)

      packages= list.natives_for_gemfile(gemfile_path)

      expect(packages).to eq %w(foo bar spam)
    end
  end
end
