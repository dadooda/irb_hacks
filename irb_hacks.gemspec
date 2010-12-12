# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{irb_hacks}
  s.version = "0.1.2.pre"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Fortuna"]
  s.date = %q{2010-12-12}
  s.description = %q{Yet another set of IRB hacks}
  s.email = %q{alex.r@askit.org}
  s.extra_rdoc_files = [
    "README.html",
    "README.md"
  ]
  s.files = [
    "CHANGELOG.md",
    "MIT-LICENSE",
    "README.html",
    "README.md",
    "Rakefile",
    "VERSION.yml",
    "irb_hacks.gemspec",
    "lib/irb_hacks.rb",
    "lib/irb_hacks/core_ext/kernel/a_and_ae.rb",
    "lib/irb_hacks/core_ext/kernel/less.rb",
    "lib/irb_hacks/snippet.rb"
  ]
  s.homepage = %q{http://github.com/dadooda/irb_hacks}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Yet another set of IRB hacks}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

