require 'spec_helper'
require 'natives/catalog/loader'

describe Natives::Catalog::Loader do
  describe "#load_from_paths" do
    let(:loader) { Natives::Catalog::Loader.new }

    it "loads files in catalog paths, in the order of given paths and sorted filenames" do
      files = {
        '/to/path1' => ['/to/path1/file1.yaml'],
        '/to/path2' => ['/to/path2/file2.yaml', '/to/path2/file1.yaml'],
        '/to/path3' => ['/to/path3/file2.yaml', '/to/path3/file1.yaml', '/to/path3/file3.yaml']
      }
      catalog_hashes = {
        '/to/path1/file1.yaml' => {"rubygems" => { "p" => "p1f1", "p1" => "p1f1", "p1f1" => "" } },
        '/to/path2/file1.yaml' => {"rubygems" => { "p" => "p2f1", "p2" => "p2f1", "p2f1" => "" } },
        '/to/path2/file2.yaml' => {"rubygems" => { "p" => "p2f2", "p2" => "p2f2", "p2f2" => "" } },
        '/to/path3/file1.yaml' => {"rubygems" => { "p" => "p3f1", "p3" => "p3f1", "p3f1" => "" } },
        '/to/path3/file2.yaml' => {"rubygems" => { "p" => "p3f2", "p3" => "p3f2", "p3f2" => "" } },
        '/to/path3/file3.yaml' => {"rubygems" => { "p" => "p3f3", "p3" => "p3f3", "p3f3" => "" } }
      }
      loader.stub(:yaml_files_in_path) { |path| files[path] }
      loader.stub(:load_yaml_file) {|file| catalog_hashes[file] }

      given_catalog_paths = ['/to/path3', '/to/path1', '/to/path2']
      expected_hash = {
        "rubygems" => {
          "p" => "p2f2",
          "p1" => "p1f1",
          "p2" => "p2f2",
          "p3" => "p3f3",
          "p1f1" => "",
          "p2f1" => "",
          "p2f2" => "",
          "p3f1" => "",
          "p3f2" => "",
          "p3f3" => ""
        }
      }

      actual_hash = loader.load_from_paths(given_catalog_paths)
      expect(actual_hash).to include(expected_hash)
    end

  end

  describe "#yaml_files_in_path" do
    let(:loader) { Natives::Catalog::Loader.new }

    it "returns a list of *.yml *.yaml filenames in the given path" do
      path = File.join(RSpec.configuration.fixture_path, 'dir_with_matching_files')
      filenames = loader.yaml_files_in_path(path)
      expected_filenames = [
        File.join(path, 'invalid1.yml'),
        File.join(path, 'valid1.yaml'),
        File.join(path, 'valid2.yml')
      ]
      expect(filenames.sort).to eq(expected_filenames.sort)
    end

    it "returns empty list if there is no matching file in the given path" do
      path = File.join(RSpec.configuration.fixture_path, 'dir_without_matching_file')
      filenames = loader.yaml_files_in_path(path)
      expect(filenames).to eq([])
    end

    it "returns empty list if the given path does not exist" do
      path = File.join(RSpec.configuration.fixture_path, 'dir_not_exists')
      filenames = loader.yaml_files_in_path(path)
      expect(filenames).to eq([])
    end
  end

  describe "#load_yaml_file" do
    let(:loader) { Natives::Catalog::Loader.new }

    it "loads the given file as YAML" do
      valid_file = File.join(RSpec.configuration.fixture_path,
        'dir_with_matching_files', 'valid1.yaml')

      hash = loader.load_yaml_file(valid_file)

      expect(hash).to include("rubygems")
    end

    it "raises error when the given file contains invalid YAML" do
      valid_file = File.join(RSpec.configuration.fixture_path,
        'dir_with_matching_files', 'invalid1.yml')

      expect {
        loader.load_yaml_file(valid_file)
      }.to raise_error
    end

    it "raises error when the given file does not exist" do
      expect {
        loader.load_yaml_file("file_not_exists.yaml")
      }.to raise_error
    end
  end
end
