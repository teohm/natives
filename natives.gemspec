# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: natives 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "natives"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Huiming Teo"]
  s.date = "2013-11-08"
  s.description = "Lookup native package dependencies required by gems."
  s.email = "teohuiming@gmail.com"
  s.executables = ["natives"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/natives",
    "catalogs/rubygems.yaml",
    "lib/natives.rb",
    "lib/natives/apps.rb",
    "lib/natives/apps/detect.rb",
    "lib/natives/apps/list.rb",
    "lib/natives/catalog.rb",
    "lib/natives/catalog/loader.rb",
    "lib/natives/catalog/merger.rb",
    "lib/natives/catalog/selector.rb",
    "lib/natives/catalog/validator.rb",
    "lib/natives/cli.rb",
    "lib/natives/gemfile_viewer.rb",
    "lib/natives/host_detection.rb",
    "lib/natives/host_detection/package_provider.rb",
    "lib/natives/host_detection/platform.rb",
    "spec/fixtures/Gemfile.empty",
    "spec/fixtures/Gemfile.empty.lock",
    "spec/fixtures/dir_with_matching_files/invalid1.yml",
    "spec/fixtures/dir_with_matching_files/not_matching.json",
    "spec/fixtures/dir_with_matching_files/valid1.yaml",
    "spec/fixtures/dir_with_matching_files/valid2.yml",
    "spec/fixtures/dir_without_matching_file/not_matching.json",
    "spec/natives/apps/detect_spec.rb",
    "spec/natives/apps/list_spec.rb",
    "spec/natives/catalog/loader_spec.rb",
    "spec/natives/catalog/merger_spec.rb",
    "spec/natives/catalog/selector_spec.rb",
    "spec/natives/catalog/validator_spec.rb",
    "spec/natives/catalog_spec.rb",
    "spec/natives/gemfile_viewer_spec.rb",
    "spec/natives/host_detection/package_provider_spec.rb",
    "spec/natives/host_detection/platform_spec.rb",
    "spec/natives/host_detection_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/teohm/natives"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "Lookup native packages required by gems."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ohai>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<debugger>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<ohai>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<debugger>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<ohai>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<debugger>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end
