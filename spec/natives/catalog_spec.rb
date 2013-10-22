require 'spec_helper'
require 'natives/catalog'

describe Natives::Catalog do

  describe "::load" do
    it "loads catalog files in the default catalog paths" do
      loader = double("loader")
      Natives::Catalog.stub(:new_loader) { loader }

      loader.should_receive(:load_from_paths).
        with(Natives::Catalog::CATALOG_PATHS).
        and_return({"foo" => {"bar" => {}}})

      hash = Natives::Catalog.load

      expect(hash).to include("foo" => {"bar" => {}})
    end
  end

  describe "::new_loader" do
    it "creates new Loader instance" do
      expect(Natives::Catalog.new_loader).
        to be_instance_of(Natives::Catalog::Loader)
    end
  end

  describe "::CATALOG_PATHS" do
    it "contains the default catalog paths" do
      expect(Natives::Catalog::CATALOG_PATHS).to eq([
        Natives::Catalog::CATALOG_PATH_IN_GEM,
        Natives::Catalog::CATALOG_PATH_IN_WORKING_DIR
      ])
    end
  end

end
