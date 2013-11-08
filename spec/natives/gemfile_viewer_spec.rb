require 'spec_helper'
require 'natives/gemfile_viewer'

describe Natives::GemfileViewer do
  describe "#packages" do
    it "list all gems specified in gemfile" do
      gemfile_path = File.join(fixture_path, "Gemfile.empty")
      gemfile = Natives::GemfileViewer.new(gemfile_path)
      expect(gemfile.gem_names).to eq(['bundler'])
    end

    it "raises error when failed to list gems in gemfile" do
      gemfile = Natives::GemfileViewer.new("gemfile_not_exist")
      expect { gemfile.gem_names }.to raise_error
    end
  end
end
