require 'spec_helper'
require 'natives/catalog/validator'

describe Natives::Catalog::Validator do

  describe "#ensure_valid_catalog_groups" do
    let(:validator) { Natives::Catalog::Validator.new }

    it "ensures catalog groups is a hash" do
      expect {
        validator.ensure_valid_catalog_groups({"rubygems" => {} })
      }.not_to raise_error
    end

    it "raises error if catalog groups is not a hash" do
      expect {
        validator.ensure_valid_catalog_groups([])
      }.to raise_error ArgumentError
    end

    it "allows catalog groups to be empty" do
      expect {
        validator.ensure_valid_catalog_groups({})
      }.not_to raise_error
    end

    it "ensures each catalog group's value is a hash" do
      expect {
        validator.ensure_valid_catalog_groups({"rubygems" => {"a" => "b"} })
      }.not_to raise_error
    end

    it "raises error if any catalog group's value is not a hash" do
      expect {
        validator.ensure_valid_catalog_groups({
          "rubygems" => {},
          "npm" => nil,
          "foo" => []
        })
      }.to raise_error(ArgumentError,
          "The following catalog group(s) should be a Hash: npm, foo")
    end
  end
end
