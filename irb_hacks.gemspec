require File.expand_path("../lib/irb_hacks/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "irb_hacks"
  s.version = IrbHacks::VERSION
  s.authors = ["Alex Fortuna"]
  s.email = ["alex.r@askit.org"]
  s.homepage = "http://github.com/dadooda/irb_hacks"

  # Copy these from class's description, adjust markup.
  s.summary = %q{Yet another set of IRB hacks}
  s.description = %q{Yet another set of IRB hacks}
  # end of s.description=

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f)}
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"
end
