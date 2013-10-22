require 'spec_helper'
require 'natives/catalog/merger'

describe Natives::Catalog::Merger do

  describe "#merge_catalog!" do
    let(:merger) { Natives::Catalog::Merger.new }

    it "validates both master_hash and hash_to_merge" do
      master_hash = {}
      hash_to_merge = {"rubygems" => {}}
      validator = double("Natives::Catalog::Validator")
      merger = Natives::Catalog::Merger.new(validator: validator)

      validator.should_receive(:ensure_valid_catalog_groups).with(master_hash)
      validator.should_receive(:ensure_valid_catalog_groups).with(hash_to_merge)

      merger.merge_catalog!(master_hash, hash_to_merge)
    end

    it "returns master_hash" do
      master_hash = {}
      expect(merger.merge_catalog!(master_hash, {})).to equal(master_hash)
    end

    it "adds new catalog group into master_hash" do
      master_hash = {}
      hash_to_merge = {"rubygems" => {}}

      merger.merge_catalog!(master_hash, hash_to_merge)

      expect(master_hash).to include("rubygems" => {})
    end

    it "adds new entries into existing catalog group" do
      master_hash = {"rubygems" => { "curb" => {} }}
      hash_to_merge = {"rubygems" => { "nokogiri" => {} }}

      merger.merge_catalog!(master_hash, hash_to_merge)

      expect(master_hash).to include(
        "rubygems" => {"curb" => {}, "nokogiri" => {}})
    end

    it "replaces existing entries in existing catalog group" do
      master_hash = {"rubygems" => {
                         "webkit-capybara" => {},
                         "curb" => {} }}
      hash_to_merge = {"rubygems" => {
                         "curb" => {"foo" => "bar"}, "nokogiri" => {} }}

      merger.merge_catalog!(master_hash, hash_to_merge)

      expect(master_hash).to include(
        "rubygems" => {
          "webkit-capybara" => {},
          "curb" => {"foo" => "bar"}, "nokogiri" => {}})
    end
  end
end
