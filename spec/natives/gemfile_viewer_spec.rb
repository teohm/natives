require 'spec_helper'
require 'natives/gemfile_viewer'

describe Natives::GemfileViewer do
  describe "#packages" do
    it "list all gems specified in gemfile" do
      gemfile_path = File.join(fixture_path, "Gemfile.with_lockfile")
      gemfile = Natives::GemfileViewer.new(gemfile_path)
      expect(gemfile.gem_names).to eq(['curb'])
      # not sure why 'bundler' gem is always excluded from the list
    end

    it "raises error when gemfile does not have lockfile" do
      gemfile_path = File.join(fixture_path, "Gemfile.no_lockfile")
      gemfile = Natives::GemfileViewer.new(gemfile_path)
      expect { gemfile.gem_names }.to raise_error
    end

    it "raises error when failed to list gems in gemfile" do
      gemfile = Natives::GemfileViewer.new("gemfile_not_exist")
      expect { gemfile.gem_names }.to raise_error
    end
  end
end
